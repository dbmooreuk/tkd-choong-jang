//
//  Move.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import Foundation

struct Move: Identifiable, Codable, Equatable {
    let id: Int
    let moveNumber: String?
    let phase: String?
    let title: String
    let korean: String?
    let description: String
    let pdfPage: Int?
    let facing: Int
    let direction: Int?
    let stanceDetails: String?
    let text1: String?
    let text2: String?
    let text3: String?
    let text4: String?
    let image: String?

    // Computed property for image asset name (from JSON values like "1.jpeg")
    var assetImageName: String? {
        guard let image = image, !image.isEmpty else { return nil }
        // Strip extension if present, so "1.jpeg" -> "1"
        if let dotIndex = image.lastIndex(of: ".") {
            return String(image[..<dotIndex])
        }
        return image
    }
}

