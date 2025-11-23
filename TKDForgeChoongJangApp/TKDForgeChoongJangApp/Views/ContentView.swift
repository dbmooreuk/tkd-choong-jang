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
    @StateObject private var storeManager = StoreManager()
    @State private var studyViewModel: StudyViewModel?

    var body: some View {
        ZStack {
            // Main content based on current screen
            switch appState.currentScreen {
            case .splash:
                SplashView()
            case .about:
                AboutView()
            case .patternList:
                PatternListView(dataStore: dataStore, storeManager: storeManager)
            case .patternInfo(let patternId):
                PatternInfoView(dataStore: dataStore, patternId: patternId)
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
            appState.completeSplash()
        }
        .onChange(of: appState.currentScreen) { _, newScreen in
            if case .study = newScreen {
                studyViewModel = StudyViewModel(dataStore: dataStore)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

