//
//  PatternFile.swift
//  TKD Forge
//
//  Created by TKD Forge
//

import Foundation

/// Represents the structure of an individual pattern JSON file
struct PatternFile: Codable {
    let id: String
    let name: String
    let belt: String
    let meaning: String
    let numberOfMoves: Int
    let moves: [Move]
}

