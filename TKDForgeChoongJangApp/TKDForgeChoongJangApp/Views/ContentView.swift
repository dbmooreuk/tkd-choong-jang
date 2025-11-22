//
//  ContentView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var dataStore = PatternDataStore()
    @State private var studyViewModel: StudyViewModel?

    var body: some View {
        ZStack {
            // Main content based on current screen
            switch appState.currentScreen {
            case .splash:
                SplashView()
            case .patternInfo:
                PatternInfoView()
                    .environmentObject(dataStore)
            case .study:
                if let viewModel = studyViewModel {
                    StudyView(viewModel: viewModel)
                        .environmentObject(dataStore)
                } else {
                    // This should never happen, but provide a fallback
                    ProgressView()
                }
            }
        }
        .onAppear {
            // Initialize studyViewModel with the dataStore
            if studyViewModel == nil {
                studyViewModel = StudyViewModel(dataStore: dataStore)
            }
            appState.completeSplash()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

