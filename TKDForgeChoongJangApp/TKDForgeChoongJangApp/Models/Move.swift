//
//  Move.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation

struct Move: Identifiable, Codable, Equatable {
    let id: Int
    let phase: String?
    let title: String
    let description: String
    let pdfPage: Int?
    let facing: Int
    let direction: Int
    let stanceDetails: String?

    // Computed property for image name
    var imageName: String {
        return "move_\(id)"
    }
}

