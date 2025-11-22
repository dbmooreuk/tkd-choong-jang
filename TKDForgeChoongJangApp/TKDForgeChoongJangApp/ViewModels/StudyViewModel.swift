//
//  StudyViewModel.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation
import Combine
import SwiftUI

class StudyViewModel: ObservableObject {
    @Published var currentMoveIndex: Int = 0
    @Published var isVoiceControlEnabled: Bool = false
    
    private let dataStore: PatternDataStore
    private var cancellables = Set<AnyCancellable>()
    
    var currentMove: Move? {
        dataStore.getMove(at: currentMoveIndex)
    }
    
    var progress: Double {
        guard !dataStore.moves.isEmpty else { return 0 }
        return Double(currentMoveIndex + 1) / Double(dataStore.moves.count)
    }
    
    var moveNumber: String {
        return "\(currentMoveIndex + 1) / \(dataStore.moves.count)"
    }
    
    init(dataStore: PatternDataStore) {
        self.dataStore = dataStore
    }
    
    func nextMove() {
        guard currentMoveIndex < dataStore.moves.count - 1 else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentMoveIndex += 1
        }
    }
    
    func previousMove() {
        guard currentMoveIndex > 0 else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentMoveIndex -= 1
        }
    }
    
    func goToMove(at index: Int) {
        guard index >= 0 && index < dataStore.moves.count else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentMoveIndex = index
        }
    }
    
    func toggleVoiceControl() {
        isVoiceControlEnabled.toggle()
    }
}

