//
//  TKDForgeChoongJangApp.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

@main
struct TKDForgeChoongJangApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

