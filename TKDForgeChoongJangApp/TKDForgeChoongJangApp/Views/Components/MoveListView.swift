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
//                Color(red: 0.12, green: 0.14, blue: 0.17)
                Color("brandDarkOverlay")
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(dataStore.moves.enumerated()), id: \.element.id) { index, move in
                            MoveListItem(
                                move: move,
                                isSelected: index == viewModel.currentMoveIndex
                            )
                            .onTapGesture {
                                viewModel.goToMove(at: index)
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
                    .foregroundColor(Color("brandOrange"))
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
                    .fill(isSelected ? Color("brandOrange") : Color.white.opacity(0.1))
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
                        .stroke(isSelected ? Color("brandOrange") : Color.clear, lineWidth: 2)
                )
        )
    }
}

#Preview {
    MoveListView(viewModel: StudyViewModel(dataStore: PatternDataStore()))
        .environmentObject(PatternDataStore())
}

