//
//  StudyView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI
import UIKit

struct StudyView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataStore: PatternDataStore
    @ObservedObject var viewModel: StudyViewModel
    @StateObject private var voiceControl = VoiceControlManager()
    @State private var showingMoveList = false
    @AppStorage("autoPlayMoveAudio") private var autoPlayMoveAudio: Bool = true
    @State private var dragOffset: CGFloat = 0
    @State private var showMoveImage: Bool = false

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

                        let hasImage = move.assetImageName != nil

                        // Move number lozenge above the card (only if moveNumber is present)
                        if let moveNumber = move.moveNumber {
                            HStack {
                                Spacer()

                                // Lozenge
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
                            .overlay(alignment: .trailing) {
                                if hasImage {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            showMoveImage.toggle()
                                        }
                                    }) {
                                        Image(systemName: showMoveImage ? "clock" : "photo")
                                            .font(.system(size: 16, weight: .semibold))
                                            .padding(8)
                                            .background(
                                                Circle()
                                                    .fill(Color.white.opacity(0.15))
                                            )
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundColor(.white)
                                    .accessibilityLabel(showMoveImage ? "Show clock" : "Show move photo")
                                    .padding(.trailing, 15)
                                }
                            }
                            .padding(.bottom, 8)
                            .padding(.top, 16)
                        }

                        MoveCard(move: move, showImage: showMoveImage && hasImage)
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
                            voiceControl.stopSpeaking()
                            viewModel.previousMove()
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex > 0 ? Color("brandYellow") : Color("brandDarkOverlay"))
                        }
                        .disabled(viewModel.currentMoveIndex == 0)

                        // Voice Control Button
                        Button(action: {
                            viewModel.toggleVoiceControl()
                            if viewModel.isVoiceControlEnabled {
                                voiceControl.startListening()

                                // Setup voice commands inline
                                voiceControl.onNextCommand = {
                                    voiceControl.stopSpeaking()
                                    viewModel.nextMove()
                                }
                                voiceControl.onBackCommand = {
                                    voiceControl.stopSpeaking()
                                    viewModel.previousMove()
                                }
                                voiceControl.onRepeatCommand = {
                                    if let move = viewModel.currentMove {
                                        voiceControl.speak(move.description)
                                    }
                                }
                                voiceControl.onToggleCommand = {
                                    let hasImage = viewModel.currentMove?.assetImageName != nil
                                    guard hasImage else { return }

                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        showMoveImage.toggle()
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
                            voiceControl.stopSpeaking()
                            viewModel.nextMove()
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(viewModel.currentMoveIndex < dataStore.moves.count - 1 ? Color("brandYellow") : Color("brandDarkOverlay"))
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
                .onAppear {
                    // Keep the screen awake while the Study view is visible.
                    UIApplication.shared.isIdleTimerDisabled = true

                    // If the audio route changes while we're listening (e.g. AirPods
                    // connect or disconnect), the VoiceControlManager will call this
                    // to force the mic button off. The user can then tap it again to
                    // restart with a clean audio configuration.
                    voiceControl.onForceVoiceControlOff = { [weak viewModel] in
                        viewModel?.setVoiceControlEnabled(false)
                    }
                }
                .onDisappear {
                    // Allow the device to sleep again when leaving the Study view.
                    UIApplication.shared.isIdleTimerDisabled = false
                    voiceControl.onForceVoiceControlOff = nil
                }
                .onChange(of: scenePhase) { newPhase in
                    // Ensure the idle timer state matches app foreground/background state.
                    if newPhase == .active {
                        UIApplication.shared.isIdleTimerDisabled = true
                    } else {
                        UIApplication.shared.isIdleTimerDisabled = false
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
                    voiceControl.stopSpeaking()
                    viewModel.nextMove()
                } else if translation > threshold {
                    voiceControl.stopSpeaking()
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

