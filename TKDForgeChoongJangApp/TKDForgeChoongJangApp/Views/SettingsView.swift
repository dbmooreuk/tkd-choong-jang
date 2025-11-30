//
//  SettingsView.swift
//  TKD Forge - Choong Jang
//

import SwiftUI
import StoreKit
import AVFoundation
import Speech
import UIKit

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var storeManager: StoreManager

    @AppStorage("autoPlayMoveAudio") private var autoPlayMoveAudio: Bool = true
    @AppStorage("speechRate") private var speechRate: Double = 0.5
    @AppStorage("speechPitch") private var speechPitch: Double = 1.0
    @AppStorage("speechVolume") private var speechVolume: Double = 1.0
    @AppStorage("speechVoiceIdentifier") private var speechVoiceIdentifier: String = "system"
    @AppStorage("clockFigureStyle") private var clockFigureStyle: String = "male"

    @State private var voiceTestSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            AppBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(spacing: 16) {
                        audioSection
                        clockFigureSection
                        permissionsSection
                        purchasesSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Button {
                appState.navigateBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text("Settings")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            Menu {
                Button("Settings") {
                    appState.navigateToSettings()
                }
                Button("About") {
                    appState.navigateToAbout()
                }
                Button("Privacy Policy") {
                    appState.navigateToPrivacyPolicy()
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }

    private var audioSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Audio & Voice")
                .font(.headline)
                .foregroundColor(.white)

            Toggle("Auto-play move audio", isOn: $autoPlayMoveAudio)
                .tint(.green)

            VStack(alignment: .leading) {
                Text("Speech rate")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Slider(value: $speechRate, in: 0.3...0.7, step: 0.05)
                Text(String(format: "%.2f", speechRate))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            VStack(alignment: .leading) {
                Text("Pitch")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Slider(value: $speechPitch, in: 0.8...1.2, step: 0.05)
                Text(String(format: "%.2f", speechPitch))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            VStack(alignment: .leading) {
                Text("Volume")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Slider(value: $speechVolume, in: 0.5...1.0, step: 0.05)
                Text(String(format: "%.2f", speechVolume))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Voice")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                let voiceOptions: [(id: String, name: String)] = {
                    var result: [(id: String, name: String)] = [(id: "system", name: "System default")]

                    let englishVoices = AVSpeechSynthesisVoice.speechVoices()
                        .filter { $0.language.hasPrefix("en") }

                    let sorted = englishVoices.sorted { lhs, rhs in
                        if lhs.language == rhs.language {
                            return lhs.name < rhs.name
                        } else {
                            return lhs.language < rhs.language
                        }
                    }

                    for voice in sorted {
                        let qualitySuffix = voice.quality == .enhanced ? " (Enhanced)" : ""
                        let displayName = "\(voice.name) – \(voice.language)\(qualitySuffix)"
                        result.append((id: voice.identifier, name: displayName))
                    }

                    return result
                }()

                Picker("Voice", selection: $speechVoiceIdentifier) {
                    ForEach(voiceOptions, id: \.id) { option in
                        Text(option.name).tag(option.id)
                    }
                }

                Button {
                    let identifier = speechVoiceIdentifier

                    let utterance = AVSpeechUtterance(string: "This is how TKD Forge will sound when reading a move description.")

                    if identifier == "system" {
                        utterance.voice = nil
                    } else if let voice = AVSpeechSynthesisVoice(identifier: identifier) {
                        utterance.voice = voice
                    } else {
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    }

                    utterance.rate = speechRate == 0 ? 0.5 : Float(speechRate)
                    utterance.pitchMultiplier = speechPitch == 0 ? 1.0 : Float(speechPitch)
                    utterance.volume = speechVolume == 0 ? 1.0 : Float(speechVolume)

                    voiceTestSynthesizer.stopSpeaking(at: .immediate)
                    voiceTestSynthesizer.speak(utterance)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Test voice")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color("brandOrange"))
                    .cornerRadius(8)
                }

                Text("Voices marked Enhanced are higher quality. To install more voices, go to iOS Settings > Accessibility > Spoken Content > Voices.")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("brandDarkOverlay"))
        )
    }

    private var clockFigureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clock Figure")
                .font(.headline)
                .foregroundColor(.white)

            Picker("Figure", selection: $clockFigureStyle) {
                Text("Male").tag("male")
                Text("Female").tag("female")
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("brandDarkOverlay"))
        )
    }

    private var permissionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Permissions")
                .font(.headline)
                .foregroundColor(.white)

            HStack {
                VStack(alignment: .leading) {
                    Text("Microphone")
                        .foregroundColor(.white)
                    Text(microphoneStatusText)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Speech Recognition")
                        .foregroundColor(.white)
                    Text(speechStatusText)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open iOS Settings")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color("brandOrange"))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("brandDarkOverlay"))
        )
    }

    private var purchasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("In-App Purchases")
                .font(.headline)
                .foregroundColor(.white)

            Text("Restore any patterns you've previously purchased with your Apple ID.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))

            Button {
                Task {
                    await storeManager.restorePurchases()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Restore Purchases")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color("brandOrange"))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("brandDarkOverlay"))
        )
    }

    private var microphoneStatusText: String {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted: return "Allowed"
        case .denied: return "Denied"
        case .undetermined: return "Not requested yet"
        @unknown default: return "Unknown"
        }
    }

    private var speechStatusText: String {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized: return "Allowed"
        case .denied, .restricted: return "Denied"
        case .notDetermined: return "Not requested yet"
        @unknown default: return "Unknown"
        }
    }
}

