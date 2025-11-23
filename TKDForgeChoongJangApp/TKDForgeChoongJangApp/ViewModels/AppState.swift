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
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var showingSplash = true
    @Published var selectedPatternId: String?

    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplash = false
                self.currentScreen = .about
            }
        }
    }

    func navigateToAbout() {
        withAnimation {
            currentScreen = .about
        }
    }

    func navigateToPatternList() {
        withAnimation {
            currentScreen = .patternList
        }
    }

    func navigateToPatternInfo(patternId: String) {
        selectedPatternId = patternId
        withAnimation {
            currentScreen = .patternInfo(patternId: patternId)
        }
    }

    func navigateToStudy() {
        withAnimation {
            currentScreen = .study
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
            default:
                break
            }
        }
    }
}

