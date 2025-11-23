//
//  MoveListView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct MoveListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: PatternDataStore
    @ObservedObject var viewModel: StudyViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(red: 0.12, green: 0.14, blue: 0.17)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(dataStore.moves) { move in
                            MoveListItem(
                                move: move,
                                isSelected: move.id == viewModel.currentMove?.id
                            )
                            .onTapGesture {
                                viewModel.goToMove(at: move.id - 1)
                                dismiss()
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("All Moves")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

struct MoveListItem: View {
    let move: Move
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Move Number
            ZStack {
                Circle()
                    .fill(isSelected ? Color.orange : Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Text("\(move.id)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            }
            
            // Move Info
            VStack(alignment: .leading, spacing: 6) {
                Text(move.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                if let phase = move.phase, !phase.isEmpty {
                    Text(phase)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(isSelected ? 0.1 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 2)
                )
        )
    }
}

#Preview {
    MoveListView(viewModel: StudyViewModel(dataStore: PatternDataStore()))
        .environmentObject(PatternDataStore())
}

