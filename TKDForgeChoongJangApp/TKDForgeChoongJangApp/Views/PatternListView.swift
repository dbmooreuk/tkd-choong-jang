//
//  PatternListView.swift
//  TKD Forge
//
//  Created by TKD Forge
//

import SwiftUI
import StoreKit

struct PatternListView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var dataStore: PatternDataStore
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text("Patterns")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await storeManager.restorePurchases()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                
                // Pattern List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(dataStore.availablePatterns) { pattern in
                            PatternRow(
                                pattern: pattern,
                                isPurchased: pattern.isFree || storeManager.isPurchased(pattern.productId ?? ""),
                                onTap: {
                                    handlePatternTap(pattern)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            
            // Loading overlay
            if storeManager.isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.orange)
                    Text("Loading...")
                        .foregroundColor(.white)
                        .padding(.top)
                }
            }
        }
        .alert("Error", isPresented: .constant(storeManager.errorMessage != nil)) {
            Button("OK") {
                storeManager.errorMessage = nil
            }
        } message: {
            if let error = storeManager.errorMessage {
                Text(error)
            }
        }
        .task {
            // Load products from App Store Connect
            let productIds = dataStore.availablePatterns.compactMap { $0.productId }
            await storeManager.loadProducts(productIds: productIds)
        }
    }
    
    private func handlePatternTap(_ pattern: PatternListItem) {
        // Check if pattern is free or already purchased
        if pattern.isFree || storeManager.isPurchased(pattern.productId ?? "") {
            // Navigate to pattern info
            appState.navigateToPatternInfo(patternId: pattern.id)
        } else {
            // Show purchase flow
            Task {
                if let product = storeManager.products.first(where: { $0.id == pattern.productId }) {
                    do {
                        let success = try await storeManager.purchase(product)
                        if success {
                            // Purchase successful, navigate to pattern
                            appState.navigateToPatternInfo(patternId: pattern.id)
                        }
                    } catch {
                        // Error handled by StoreManager
                    }
                }
            }
        }
    }
}

struct PatternRow: View {
    let pattern: PatternListItem
    let isPurchased: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(pattern.belt)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                // Status indicator
                if isPurchased {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                } else if let price = pattern.price {
                    Text(String(format: "£%.2f", price))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isPurchased ? Color.green.opacity(0.5) : Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    PatternListView(dataStore: PatternDataStore(), storeManager: StoreManager())
        .environmentObject(AppState())
}

