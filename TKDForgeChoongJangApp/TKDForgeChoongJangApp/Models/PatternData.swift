//
//  PatternData.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation
import Combine

struct PatternInfo {
    let name: String
    let meaning: String
    let numberOfMoves: Int
    let belt: String
    
    static let choongJang = PatternInfo(
        name: "Choong-Jang",
        meaning: "Choong-Jang is the pseudonym of General Kim Duk Ryang who lived during the Lee Dynasty, 14th century. This pattern consists of 52 movements.",
        numberOfMoves: 52,
        belt: "2nd Dan Black Belt"
    )
}

class PatternDataStore: ObservableObject {
    @Published var moves: [Move] = []
    @Published var isLoading = true
    @Published var error: String?
    
    let patternInfo = PatternInfo.choongJang
    
    init() {
        loadMoves()
    }
    
    private func loadMoves() {
        guard let url = Bundle.main.url(forResource: "pattern-data", withExtension: "json") else {
            error = "Could not find pattern-data.json"
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            moves = try decoder.decode([Move].self, from: data)
            isLoading = false
        } catch {
            self.error = "Error loading pattern data: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func getMove(at index: Int) -> Move? {
        guard index >= 0 && index < moves.count else { return nil }
        return moves[index]
    }
}

