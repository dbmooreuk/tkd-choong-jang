//
//  AppState.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI
import Combine

enum AppScreen: Equatable {
    case splash
    case about
    case patternList
    case patternInfo(patternId: String)
    case study
    case settings
    case privacyPolicy
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var showingSplash = true
    @Published var selectedPatternId: String?
    @Published private(set) var lastMainScreen: AppScreen = .about

    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplash = false
                self.currentScreen = .about
                self.lastMainScreen = .about
            }
        }
    }

    func navigateToAbout() {
        withAnimation {
            currentScreen = .about
            lastMainScreen = .about
        }
    }

    func navigateToPatternList() {
        withAnimation {
            currentScreen = .patternList
            lastMainScreen = .patternList
        }
    }

    func navigateToPatternInfo(patternId: String) {
        selectedPatternId = patternId
        withAnimation {
            currentScreen = .patternInfo(patternId: patternId)
            lastMainScreen = .patternInfo(patternId: patternId)
        }
    }

    func navigateToStudy() {
        withAnimation {
            currentScreen = .study
            lastMainScreen = .study
        }
    }

    func navigateToSettings() {
        withAnimation {
            currentScreen = .settings
        }
    }

    func navigateToPrivacyPolicy() {
        withAnimation {
            currentScreen = .privacyPolicy
        }
    }

    func navigateBack() {
        withAnimation {
            switch currentScreen {
            case .study:
                if let patternId = selectedPatternId {
                    currentScreen = .patternInfo(patternId: patternId)
                } else {
                    currentScreen = .patternList
                }
            case .patternInfo:
                currentScreen = .patternList
            case .patternList:
                currentScreen = .about
            case .about:
                currentScreen = .splash
            case .settings, .privacyPolicy:
                currentScreen = lastMainScreen
            case .splash:
                break
            }

            if currentScreen != .settings && currentScreen != .privacyPolicy {
                lastMainScreen = currentScreen
            }
        }
    }
}

