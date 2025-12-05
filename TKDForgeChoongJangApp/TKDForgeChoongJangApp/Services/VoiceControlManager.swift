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

class VoiceControlManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isListening = false
    @Published var isAuthorized = false
    @Published var lastCommand: String = ""

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()

    var onNextCommand: (() -> Void)?
    var onBackCommand: (() -> Void)?
    var onRepeatCommand: (() -> Void)?
    var onToggleCommand: (() -> Void)?
    var onForceVoiceControlOff: (() -> Void)?

    private var routeChangeObserver: NSObjectProtocol?
    private var lastSpeechFinishedAt: Date?
    private var isInputTapInstalled = false

    override init() {
        super.init()
        // Authorization is now requested on-demand in startListening()
        // to avoid issues when the view is first created.

        // Use this manager as the delegate for spoken move descriptions so
        // we can pause/resume the microphone around speech.
        synthesizer.delegate = self

        // Listen for audio route changes (e.g. AirPods connect/disconnect)
        // so we can switch cleanly between headset and built-in mic/speaker.
        routeChangeObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleRouteChange(notification: notification)
        }
    }


    deinit {
        if let observer = routeChangeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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

        // If we're already running, treat this as a toggle to turn
        // listening off.
        if audioEngine.isRunning {
            stopListening()
            return
        }

        do {
            try startRecording()
            isListening = true
        } catch {
            print("Could not start recording: \(error)")
            isListening = false
        }
    }

    func stopListening() {
        // Stop the current engine and tear down any existing tap.
        audioEngine.stop()

        let inputNode = audioEngine.inputNode
        if isInputTapInstalled {
            inputNode.removeTap(onBus: 0)
            isInputTapInstalled = false
        }

        audioEngine.reset()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isListening = false

        // Recreate the engine so that the next time we start listening we
        // always have a fresh graph that matches the current hardware route
        // (important when AirPods connect or disconnect).
        audioEngine = AVAudioEngine()
    }

    private func startRecording() throws {
        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord,
                                     mode: .spokenAudio,
                                     options: [.duckOthers, .allowBluetooth, .allowBluetoothA2DP])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // Apply our standard routing rule based on the current route.
        try updateAudioRoute(for: audioSession)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            throw NSError(domain: "VoiceControl", code: -1, userInfo: nil)
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            // Always hop back to the main queue before mutating any
            // AVAudioEngine state to avoid races with UI actions.
            DispatchQueue.main.async {
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
                    // When the speech task finishes or errors, tear everything
                    // down cleanly. The user can re-enable voice control with
                    // the mic button.
                    self.stopListening()
                }
            }
        }

        // Make sure there is no stale tap left around from a previous
        // recording session (for example before/after a Bluetooth route
        // change) before installing a new one.
        if isInputTapInstalled {
            inputNode.removeTap(onBus: 0)
            isInputTapInstalled = false
        }

        // Use the input format for the current route so that the tap
        // always matches the hardware configuration (built-in mic vs
        // AirPods, etc.).
        let recordingFormat = inputNode.inputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        isInputTapInstalled = true

        audioEngine.prepare()
        try audioEngine.start()
    }
    private func updateAudioRoute(for audioSession: AVAudioSession) throws {
        // Routing rule:
        // - If headphones / AirPods / Bluetooth audio are connected, let iOS
        //   route audio to them naturally.
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
            // Clear any previous speaker override so audio follows the
            // currently selected route (e.g. AirPods, wired headphones).
            try audioSession.overrideOutputAudioPort(.none)
        } else {
            // No external outputs – explicitly use the loudspeaker instead of
            // the phone earpiece.
            try audioSession.overrideOutputAudioPort(.speaker)
        }
    }

    private func handleRouteChange(notification: Notification) {
        let audioSession = AVAudioSession.sharedInstance()

        // Always keep output routing up to date so spoken descriptions go to
        // the right place (speaker vs AirPods).
        do {
            try updateAudioRoute(for: audioSession)
        } catch {
            print("VoiceControlManager: failed to update audio route after change: \(error)")
        }

        // Only auto-disable voice control for real device changes (e.g.
        // AirPods/headphones plugged in or removed). Ignore route changes
        // caused by us changing the audio category, otherwise the mic
        // appears to "bounce" off as soon as the user enables it.
        guard isListening else { return }

        if let reasonValue = notification.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt,
           let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue),
           reason == .newDeviceAvailable || reason == .oldDeviceUnavailable {
            stopListening()
            DispatchQueue.main.async { [weak self] in
                self?.onForceVoiceControlOff?()
            }
        }
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

        // To avoid the app reacting to its *own* spoken descriptions
        // (e.g. a move that contains the word "back"), we ignore
        // navigation commands while the synthesizer is speaking, and
        // for a short moment after speech has finished. This allows
        // any buffered audio from the phone's speaker to "clear" from
        // the recogniser.
        if synthesizer.isSpeaking {
            return
        }

        if let lastEnd = lastSpeechFinishedAt {
            let sinceEnd = Date().timeIntervalSince(lastEnd)
            if sinceEnd < 0.75 {
                return
            }
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

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        lastSpeechFinishedAt = Date()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        lastSpeechFinishedAt = Date()
    }
}

