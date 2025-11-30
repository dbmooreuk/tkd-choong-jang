//
//  VoiceControlManager.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//


import Speech
import Foundation
import Combine
import AVFoundation 

class VoiceControlManager: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var isAuthorized = false
    @Published var lastCommand: String = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()
    
    var onNextCommand: (() -> Void)?
    var onBackCommand: (() -> Void)?
    var onRepeatCommand: (() -> Void)?
    var onToggleCommand: (() -> Void)?

    override init() {
        super.init()
        // Authorization is now requested on-demand in startListening()
        // to avoid issues when the view is first created.
    }

    func requestAuthorization(completion: (() -> Void)? = nil) {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                self?.isAuthorized = authStatus == .authorized
                completion?()
            }
        }
    }

    func startListening() {
        if !isAuthorized {
            // Request authorization first, then start listening if granted
            requestAuthorization { [weak self] in
                guard let self = self, self.isAuthorized else { return }
                self.startListening()
            }
            return
        }

        if audioEngine.isRunning {
            stopListening()
            return
        }

        do {
            try startRecording()
            isListening = true
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isListening = false
    }
    
    private func startRecording() throws {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord,
                                     mode: .spokenAudio,
                                     options: [.duckOthers])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // Routing rule:
        // - If headphones / AirPods / Bluetooth audio are connected, use them.
        // - Otherwise, play through the phone's loudspeaker (not the ear piece).
        let hasHeadphonesOrBluetooth = audioSession.currentRoute.outputs.contains { output in
            switch output.portType {
            case .headphones, .bluetoothA2DP, .bluetoothHFP, .bluetoothLE:
                return true
            default:
                return false
            }
        }

        if hasHeadphonesOrBluetooth {
            try audioSession.overrideOutputAudioPort(.none)
        } else {
            try audioSession.overrideOutputAudioPort(.speaker)
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "VoiceControl", code: -1, userInfo: nil)
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                let transcription = result.bestTranscription.formattedString.lowercased()
                self.lastCommand = transcription

                // Use only the most recently spoken word to decide the command
                if let lastSegment = result.bestTranscription.segments.last {
                    let lastWord = lastSegment.substring.lowercased()
                    self.processCommand(lastWord)
                }
            }
            
            if error != nil || result?.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isListening = false
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    private func processCommand(_ command: String) {
        // Normalise for safety, although the caller already lowercases.
        let cmd = command.lowercased()

        // "Stop" should always work, even while speaking – it just
        // interrupts the current utterance but does not change the move.
        if cmd.contains("stop") {
            stopSpeaking()
            return
        }

        let isSpeaking = synthesizer.isSpeaking

        // To avoid the app reacting to its *own* spoken descriptions
        // (e.g. a move that contains the word "back"), we ignore
        // navigation commands while the synthesizer is speaking.
        // The user can still say "Stop" at any time.
        if isSpeaking {
            return
        }

        if cmd.contains("next") {
            onNextCommand?()
        } else if cmd.contains("back") || cmd.contains("previous") {
            onBackCommand?()
        } else if cmd.contains("repeat") || cmd.contains("again") {
            onRepeatCommand?()
        } else if cmd.contains("toggle") {
            onToggleCommand?()
        } else if cmd.contains("start") || cmd.contains("play") {
            // Treat "start" and "play" the same as "repeat" once the
            // app has finished speaking.
            onRepeatCommand?()
        }
    }

    func speak(_ text: String) {
        // Always cancel any in-progress or queued speech before starting
        // a new utterance so that moves don't "stack up" when the user
        // navigates quickly.
        synthesizer.stopSpeaking(at: .immediate)

        let utterance = AVSpeechUtterance(string: text)

        let defaults = UserDefaults.standard
        let rate = defaults.double(forKey: "speechRate")
        let pitch = defaults.double(forKey: "speechPitch")
        let volume = defaults.double(forKey: "speechVolume")
        let voiceIdentifier = defaults.string(forKey: "speechVoiceIdentifier") ?? "system"

        if voiceIdentifier == "system" {
            // Use the system's preferred voice (including any enhanced voices the user has installed)
            utterance.voice = nil
        } else if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            // Fallback if the selected voice is no longer available
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        utterance.rate = rate == 0 ? 0.5 : Float(rate)
        utterance.pitchMultiplier = pitch == 0 ? 1.0 : Float(pitch)
        utterance.volume = volume == 0 ? 1.0 : Float(volume)

        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

