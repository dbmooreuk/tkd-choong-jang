//
//  PrivacyPolicyView.swift
//  TKD Forge - Choong Jang
//

import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            AppBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Privacy Policy for TKD Forge - Choong Jang")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Last updated: [Date]")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))

                        Group {
                            Text("Information Collection")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("TKD Forge - Choong Jang does not collect, store, or transmit any personal information.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("On-Device Processing")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("All speech recognition and audio processing used by the app is performed on your device using Apple's frameworks. No audio or transcripts are sent to our servers.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("Permissions")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The app requests access to the microphone and speech recognition in order to enable hands-free voice control and spoken descriptions of pattern movements. These permissions are only used while you are actively using the app's study features.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("Data Sharing")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("TKD Forge - Choong Jang does not share any data with third parties. There are no analytics SDKs, advertising networks, or external tracking tools integrated into the app.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("In-App Purchases")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("The app uses Apple's in-app purchase system to unlock additional patterns. Payment and purchase history are handled by Apple and associated with your Apple ID. We do not have access to your payment information.")
                                .foregroundColor(.white.opacity(0.9))
                        }

                        Group {
                            Text("Contact")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("If you have any questions about this privacy policy or how your data is handled, please contact us at [your-email].")
                                .foregroundColor(.white.opacity(0.9))
                        }
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

            Text("Privacy Policy")
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
}

