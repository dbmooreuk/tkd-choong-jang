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
        VStack(spacing: 24) {
            // Clock Visualizer
            ClockVisualizer(facing: move.facing, direction: move.direction)
                .padding(.top, 20)
            
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
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 200)
                
                // Placeholder or actual image
                if let image = UIImage(named: move.imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(20)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "figure.martial.arts")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Move \(move.id)")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Move Title
            Text(move.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
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
                        .padding(.horizontal, 30)
                    
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
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    ZStack {
        Color.black
        MoveCard(move: Move(
            id: 1,
            phase: "Phase 1: Opening Attacks",
            title: "Step R, Block",
            description: "Step Right (to 3:00) into a Sitting Stance, but keep your chest facing Front (12:00). Side Front Block (Right hand).",
            pdfPage: 14,
            facing: 12,
            direction: 3,
            stanceDetails: nil
        ))
    }
}

