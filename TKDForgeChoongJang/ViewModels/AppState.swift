//
//  AppState.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation

enum AppScreen {
    case splash
    case patternInfo
    case study
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var showingSplash = true
    
    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplash = false
                self.currentScreen = .patternInfo
            }
        }
    }
    
    func navigateToStudy() {
        withAnimation {
            currentScreen = .study
        }
    }
    
    func navigateToPatternInfo() {
        withAnimation {
            currentScreen = .patternInfo
        }
    }
}

