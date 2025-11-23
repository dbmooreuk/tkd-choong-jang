//
//  PatternInfoView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct PatternInfoView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var dataStore: PatternDataStore
    @State private var showContent = false
    let patternId: String
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                // Header with back button
                HStack {
                    Button(action: {
                        appState.navigateBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.orange)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Image("logo_tkd_forge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)

//                        Text("TKD FORGE")
//                            .font(.system(size: 16, weight: .bold, design: .rounded))
//                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // Pattern Info Card
                if let patternInfo = dataStore.patternInfo {
                    VStack(spacing: 24) {
                        // Pattern Name
                        VStack(spacing: 8) {
                            Text(patternInfo.name)
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(Color("brandOrange"))

                            Text(patternInfo.belt)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                )
                        }

                        // Divider
                        Rectangle()
                            .fill(Color.orange.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal, 40)

                        // Meaning
                        Text(patternInfo.meaning)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 30)

                        // Move Count
                        HStack(spacing: 12) {
                            Image(systemName: "figure.martial.arts")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(patternInfo.numberOfMoves)")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)

                                Text("Movements")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(40)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color("brandDarkOverlay"))
                    )
                    .padding(.horizontal, 30)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                } else if dataStore.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.orange)
                        .padding()
                } else if let error = dataStore.error {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)

                        Text("Error Loading Pattern")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Begin Study Button
                Button(action: {
                    appState.navigateToStudy()
                }) {
                    HStack(spacing: 12) {

                        Text("Begin Study")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color("brandOrange"))
                  
                    .cornerRadius(8)
                    .shadow(color: .orange.opacity(0.4), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }
        .onAppear {
            // Load the pattern data
            dataStore.loadPattern(id: patternId)

            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview {
    PatternInfoView(dataStore: PatternDataStore(), patternId: "choong-jang")
        .environmentObject(AppState())
}
