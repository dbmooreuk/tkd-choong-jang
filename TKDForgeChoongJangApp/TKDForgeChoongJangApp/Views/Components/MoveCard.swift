//
//  MoveCard.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct MoveCard: View {
    let move: Move

    var body: some View {
        VStack(spacing: 20) {
            // Top row: clock + directional hints panel
            HStack(alignment: .top, spacing: 16) {
                ClockVisualizer(facing: move.facing, direction: move.direction)
                    .padding(.top, 4)

                if move.text1 != nil || move.text2 != nil || move.text3 != nil || move.text4 != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        DirectionHintRow(text: move.text1)
                        DirectionHintRow(text: move.text2)
                        DirectionHintRow(text: move.text3)
                        DirectionHintRow(text: move.text4)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color("brandDark"))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 24)
//                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
//                            )
                    )
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color("brandDarkOverlay"))
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Legend row under clock
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 3)
                    Text("Facing")
                }
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 24, height: 3)
                    Text("Move direction")
                }
            }
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.8))
            .padding(.horizontal, 24)

            // Phase Badge (optional)
            if let phase = move.phase, !phase.isEmpty {
                Text(phase)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.2))
                    )
            }

            // Move Image
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color.white.opacity(0.05))
//                    .frame(height: 220)
//
//                // Placeholder or actual image
//                if let image = UIImage(named: move.imageName) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 220)
//                        .cornerRadius(20)
//                } else {
//                    VStack(spacing: 12) {
//                        Image(systemName: "figure.martial.arts")
//                            .font(.system(size: 60))
//                            .foregroundColor(.white.opacity(0.3))
//
//                        Text("Move \(move.id)")
//                            .font(.system(size: 16, weight: .medium, design: .rounded))
//                            .foregroundColor(.white.opacity(0.5))
//                    }
//                }
//            }
//            .padding(.horizontal, 8)

            // Move Title
            Text(move.title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Move Description
            ScrollView {
                VStack(spacing: 12) {
                    Text(move.description)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 24)

                    if let stanceDetails = move.stanceDetails {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.yellow)

                            Text(stanceDetails)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.yellow.opacity(0.1))
                        )
                        .padding(.top, 8)
                    }
                }
            }
            .frame(maxHeight: 120)
        }
        .padding(.vertical,0)
//        .background(
//            RoundedRectangle(cornerRadius: 30)
//                .fill(Color.white.opacity(0.05))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 30)
//                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
//                )
//        )
        .padding(.horizontal, 0)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct DirectionHintRow: View {
    let text: String?

    private var parts: (label: String, value: String)? {
        guard let raw = text?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
            return nil
        }
        let components = raw.split(separator: "/", maxSplits: 1).map { String($0).trimmingCharacters(in: .whitespaces) }
        if components.count == 2 {
            return (label: components[0], value: components[1])
        } else {
            return (label: raw, value: "")
        }
    }

    var body: some View {
        if let parts = parts {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(parts.label)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                
                
                if !parts.value.isEmpty {
                    Text(parts.value)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)

                }
            }
        }
    }
}

#Preview {
    ZStack {
        AppBackground()
        MoveCard(move: Move(
            id: 1,
            phase: "Phase 1: Opening Attacks",
            title: "Step R, Block",
            description: "Step Right (to 3:00) into a Sitting Stance, but keep your chest facing Front (12:00). Side Front Block (Right hand).",
            pdfPage: 14,
            facing: 12,
            direction: 3,
            stanceDetails: nil,
            text1: "Turn/Left",
            text2: "Face/12 o'clock",
            text3: "Slide back/6 o'clock",
            text4: "Jump back/6 o'clock"
        ))
    }
}

