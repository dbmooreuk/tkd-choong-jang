//
//  StudyView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct StudyView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: PatternDataStore
    @ObservedObject var viewModel: StudyViewModel
    @StateObject private var voiceControl = VoiceControlManager()
    @State private var showingMoveList = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.14, blue: 0.17),
                    Color(red: 0.18, green: 0.20, blue: 0.24)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            appState.navigateBack()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                        }

                        Spacer()

                        Text(dataStore.patternInfo?.name ?? "Pattern")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            showingMoveList.toggle()
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                    .padding(.bottom, 20)

                    // Progress Bar
                    ProgressView(value: viewModel.progress)
                        .tint(.orange)
                        .padding(.horizontal, 20)

                    // Move Counter
                    Text(viewModel.moveNumber)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)

                    Spacer()

                    // Main Card
                    if let move = viewModel.currentMove {
                        MoveCard(move: move)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                            .id(move.id)
                    }

                    Spacer()

                    // Navigation Controls
                    HStack(spacing: 40) {
                        // Previous Button
                        Button(action: {
                            viewModel.previousMove()
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex > 0 ? .orange : .gray.opacity(0.3))
                        }
                        .disabled(viewModel.currentMoveIndex == 0)

                        // Voice Control Button
                        Button(action: {
                            viewModel.toggleVoiceControl()
                            if viewModel.isVoiceControlEnabled {
                                voiceControl.startListening()

                                // Setup voice commands inline
                                voiceControl.onNextCommand = {
                                    viewModel.nextMove()
                                }
                                voiceControl.onBackCommand = {
                                    viewModel.previousMove()
                                }
                                voiceControl.onRepeatCommand = {
                                    if let move = viewModel.currentMove {
                                        voiceControl.speak(move.description)
                                    }
                                }
                            } else {
                                voiceControl.stopListening()
                            }
                        }) {
                            Image(systemName: viewModel.isVoiceControlEnabled ? "mic.fill" : "mic.slash.fill")
                                .font(.system(size: 40))
                                .foregroundColor(viewModel.isVoiceControlEnabled ? .red : .white.opacity(0.5))
                        }

                        // Next Button
                        Button(action: {
                            viewModel.nextMove()
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex < dataStore.moves.count - 1 ? .orange : .gray.opacity(0.3))
                        }
                        .disabled(viewModel.currentMoveIndex >= dataStore.moves.count - 1)
                    }
                    .padding(.bottom, 50)
                }
                .sheet(isPresented: $showingMoveList) {
                    MoveListView(viewModel: viewModel)
                        .environmentObject(dataStore)
                }
                .onChange(of: viewModel.currentMove) { _, newMove in
                    // Only speak when the user explicitly changes moves
                    // via buttons or voice command handlers.
                    if viewModel.isVoiceControlEnabled, let move = newMove {
                        voiceControl.speak(move.description)
                    }
                }
        }
    }
}

