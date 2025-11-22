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
                                     options: [.duckOthers, .defaultToSpeaker])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
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
        if command.contains("next") {
            onNextCommand?()
        } else if command.contains("back") || command.contains("previous") {
            onBackCommand?()
        } else if command.contains("repeat") || command.contains("again") {
            onRepeatCommand?()
        }
    }
    
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

