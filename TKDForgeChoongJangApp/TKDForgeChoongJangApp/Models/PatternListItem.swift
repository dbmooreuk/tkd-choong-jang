//
//  PatternListItem.swift
//  TKD Forge
//
//  Created by TKD Forge
//

import Foundation

/// Represents a pattern entry from patterns.json
struct PatternListItem: Identifiable, Codable {
    let id: String
    let name: String
    let belt: String
    let meaning: String
    let numberOfMoves: Int
    let jsonFile: String
    let productId: String?
    let price: Double?
    
    /// Returns true if this pattern requires a purchase
    var requiresPurchase: Bool {
        return productId != nil
    }
    
    /// Returns true if this pattern is free (no productId or price is null)
    var isFree: Bool {
        return productId == nil || price == nil
    }
}

