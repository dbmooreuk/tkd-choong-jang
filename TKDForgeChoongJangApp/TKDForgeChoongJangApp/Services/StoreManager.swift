//
//  StoreManager.swift
//  TKD Forge
//
//  Created by TKD Forge
//

import Foundation
import StoreKit
import Combine

/// Manages in-app purchases using StoreKit 2
@MainActor
class StoreManager: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var updateListenerTask: Task<Void, Never>?

    init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()
        
        // Load purchased products from UserDefaults
        loadPurchasedProducts()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    /// Load products from App Store Connect
    func loadProducts(productIds: [String]) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loadedProducts = try await Product.products(for: productIds)
            products = loadedProducts
            isLoading = false
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Purchase a product
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // Verify the transaction
            let transaction = try checkVerified(verification)
            
            // Mark as purchased
            purchasedProductIDs.insert(transaction.productID)
            savePurchasedProducts()
            
            // Finish the transaction
            await transaction.finish()
            
            return true
            
        case .userCancelled:
            return false
            
        case .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    /// Restore purchases
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Sync with App Store
            try await AppStore.sync()
            
            // Check all transactions
            for await result in Transaction.currentEntitlements {
                let transaction = try checkVerified(result)
                purchasedProductIDs.insert(transaction.productID)
            }
            
            savePurchasedProducts()
            isLoading = false
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    /// Check if a product has been purchased
    func isPurchased(_ productId: String) -> Bool {
        return purchasedProductIDs.contains(productId)
    }
    
    /// Listen for transaction updates
    private func listenForTransactions() -> Task<Void, Never> {
        Task { [weak self] in
            guard let self = self else { return }
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    self.purchasedProductIDs.insert(transaction.productID)
                    self.savePurchasedProducts()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }

    /// Verify a transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    /// Save purchased products to UserDefaults
    private func savePurchasedProducts() {
        let array = Array(purchasedProductIDs)
        UserDefaults.standard.set(array, forKey: "purchasedProducts")
    }
    
    /// Load purchased products from UserDefaults
    private func loadPurchasedProducts() {
        if let array = UserDefaults.standard.array(forKey: "purchasedProducts") as? [String] {
            purchasedProductIDs = Set(array)
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

