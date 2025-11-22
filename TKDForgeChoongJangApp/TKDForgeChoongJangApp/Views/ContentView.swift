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
                StudyView()
                    .environmentObject(dataStore)
            }
        }
        .onAppear {
            appState.completeSplash()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

