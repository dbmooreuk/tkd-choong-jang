//
//  PatternData.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation
import Combine

struct PatternInfo {
    let id: String
    let name: String
    let meaning: String
    let numberOfMoves: Int
    let belt: String
}

class PatternDataStore: ObservableObject {
    @Published var moves: [Move] = []
    @Published var patternInfo: PatternInfo?
    @Published var isLoading = true
    @Published var error: String?
    @Published var availablePatterns: [PatternListItem] = []

    init() {
        loadAvailablePatterns()
    }

    /// Load the list of available patterns from patterns.json
    func loadAvailablePatterns() {
        guard let url = Bundle.main.url(forResource: "patterns", withExtension: "json") else {
            error = "Could not find patterns.json"
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            availablePatterns = try decoder.decode([PatternListItem].self, from: data)
        } catch {
            self.error = "Error loading patterns list: \(error.localizedDescription)"
        }
    }

    /// Load a specific pattern by its ID
    func loadPattern(id: String) {
        isLoading = true
        error = nil

        // Find the pattern in the available patterns list
        guard let patternItem = availablePatterns.first(where: { $0.id == id }) else {
            error = "Pattern not found: \(id)"
            isLoading = false
            return
        }

        // Get the JSON filename without extension
        let filename = patternItem.jsonFile.replacingOccurrences(of: ".json", with: "")

        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            error = "Could not find \(patternItem.jsonFile)"
            isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()

            // Try to decode as PatternFile (new format with metadata)
            if let patternFile = try? decoder.decode(PatternFile.self, from: data) {
                self.patternInfo = PatternInfo(
                    id: patternFile.id,
                    name: patternFile.name,
                    meaning: patternFile.meaning,
                    numberOfMoves: patternFile.numberOfMoves,
                    belt: patternFile.belt
                )
                self.moves = patternFile.moves
            } else {
                // Fallback: try to decode as array of moves (old format)
                let movesArray = try decoder.decode([Move].self, from: data)
                self.patternInfo = PatternInfo(
                    id: patternItem.id,
                    name: patternItem.name,
                    meaning: patternItem.meaning,
                    numberOfMoves: patternItem.numberOfMoves,
                    belt: patternItem.belt
                )
                self.moves = movesArray
            }

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

