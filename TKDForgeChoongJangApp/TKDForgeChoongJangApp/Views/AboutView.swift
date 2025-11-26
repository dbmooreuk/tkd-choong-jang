//
//  AboutView.swift
//  TKD Forge
//
//  Created by TKD Forge
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            AppBackground()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with burger menu
                HStack {
                    // No back button on About; keep layout balanced
                    Color.clear
                        .frame(width: 44, height: 44)

                    Spacer()

                    Text("About")
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

                Spacer()

                VStack(spacing: 30) {
                    // Logo
                    Image("logo_tkd_forge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .shadow(color: .orange.opacity(0.5), radius: 20)

                    // App Title
                    VStack(spacing: 8) {
        //                    Text("TKD FORGE")
        //                        .font(.system(size: 36, weight: .bold, design: .rounded))
        //                        .foregroundColor(.white)

                        Text("Master Your Patterns")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(Color("brandYellow"))
                    }

                    // Description
                    VStack(spacing: 16) {
                        Text("Learn and perfect your Taekwondo patterns with interactive study tools, voice control, and visual guides.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(1))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        Text("Each pattern includes detailed move descriptions, visual clock diagrams, and step-by-step guidance.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    // Call to Action Button
                    Button(action: {
                        appState.navigateToPatternList()
                    }) {
                        HStack {
                            Text("Explore Patterns")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color("brandOrange"))
                        .cornerRadius(30)
        //                    .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview {
    AboutView()
        .environmentObject(AppState())
}
