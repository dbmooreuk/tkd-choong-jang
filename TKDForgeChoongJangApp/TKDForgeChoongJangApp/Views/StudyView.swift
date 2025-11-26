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
    @AppStorage("autoPlayMoveAudio") private var autoPlayMoveAudio: Bool = true
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Background
//            LinearGradient(
//                colors: [
//                    Color(red: 0.12, green: 0.14, blue: 0.17),
//                    Color(red: 0.18, green: 0.20, blue: 0.24)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
            AppBackground()
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

                    ProgressView(value: viewModel.progress)
                        .tint(.green)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

//                    Spacer()

                    // Main Card
                    if let move = viewModel.currentMove {
                        
                        // Move number lozenge above the card (only if moveNumber is present)
                        if let moveNumber = move.moveNumber {
                            HStack {
                                Spacer()
                                Text("Move: \(moveNumber)")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.15))
                                    )
                                Spacer()
                            }
                            .padding(.bottom, 8)
                            .padding(.top, 16)
                        }

                        MoveCard(move: move)
                            .offset(x: dragOffset)
                            .gesture(moveDragGesture)
                            .transition(.asymmetric(
                                insertion: .move(edge: viewModel.isMovingForward ? .trailing : .leading).combined(with: .opacity),
                                removal: .move(edge: viewModel.isMovingForward ? .leading : .trailing).combined(with: .opacity)
                            ))
                            .id(move.id)
                    }

                    Spacer()

                    // Navigation Controls
                    HStack(spacing: 86) {
                        // Previous Button
                        Button(action: {
                            viewModel.previousMove()
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex > 0 ? Color("brandOrange") : Color("brandDarkOverlay"))
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
                                // When the user turns voice control off, stop
                                // both listening and any speech that is
                                // currently playing.
                                voiceControl.stopListening()
                                voiceControl.stopSpeaking()
                            }
                        }) {
                            Image(systemName: viewModel.isVoiceControlEnabled ? "mic.fill" : "mic.slash.fill")
                                .font(.system(size: 40))
                                .foregroundColor(viewModel.isVoiceControlEnabled ? .green : Color("brandDarkOverlay"))
                        }

                        // Next Button
                        Button(action: {
                            viewModel.nextMove()
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex < dataStore.moves.count - 1 ? Color("brandOrange") : Color("brandDarkOverlay"))
                        }
                        .disabled(viewModel.currentMoveIndex >= dataStore.moves.count - 1)
                    }
                    .padding(.bottom, 0)
                }
                .sheet(isPresented: $showingMoveList) {
                    MoveListView(viewModel: viewModel)
                        .environmentObject(dataStore)
                }
                .onChange(of: viewModel.currentMove) { _, newMove in
                    // Auto-play audio for each move when voice control is enabled
                    // and the user has turned on auto-play in Settings.
                    if viewModel.isVoiceControlEnabled && autoPlayMoveAudio, let move = newMove {
                        voiceControl.speak(move.description)
                    }
                }
        }
    }

    private var moveDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let translation = value.translation.width
                let threshold: CGFloat = 60
                if translation < -threshold {
                    viewModel.nextMove()
                } else if translation > threshold {
                    viewModel.previousMove()
                }
                withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                    dragOffset = 0
                }
            }
    }
}

#Preview {
    let store = PatternDataStore()
    // Configure store with sample data
    // store.patternInfo = PatternInfo(name: "Choong-Jang", belt: "Red", numberOfMoves: 52, meaning: "...")
    // store.moves = [Move(...), Move(...), ...]

    let vm = StudyViewModel(dataStore: store)
    // Optionally set current move index for testing animations and states
     vm.currentMoveIndex = 3

    return StudyView(viewModel: vm)
        .environmentObject(AppState())
        .environmentObject(store)
}

