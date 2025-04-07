//
//  SubscriptionManager.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import StoreKit

enum SubscriptionTier: String, CaseIterable {
    case pro = "com.universe.subscription.pro"
    
    var id: String { rawValue }
    
    static var allIDs: [String] {
        allCases.map { $0.id }
    }
}

class SubscriptionManager {
    static let shared = SubscriptionManager()
    
    private init() {}
    
    private(set) var products: [Product] = []
    private(set) var purchasedSubscriptions: Set<String> = []
    
    // Request product information from App Store
    func requestProducts() async throws {
        products = try await Product.products(for: SubscriptionTier.allIDs)
    }
    
    // Check if user has any active subscriptions
    func hasActiveSubscription() -> Bool {
        !purchasedSubscriptions.isEmpty
    }
    
    // Purchase a product
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                // User gets access to the content
                await transaction.finish()
                await refreshPurchasedSubscriptions()
                return transaction
            case .unverified:
                throw SubscriptionError.networkError
            }
        case .userCancelled:
            return nil
        case .pending:
            throw SubscriptionError.pendingPurchase
        default:
            throw SubscriptionError.unknown
        }
    }
    
    // Refresh the list of purchased subscriptions
    @MainActor
    func refreshPurchasedSubscriptions() async {
        purchasedSubscriptions.removeAll()
        
        // Get all entitlements from StoreKit
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            
            // Skip if revoked or expired
            if transaction.revocationDate != nil { continue }
            if let expirationDate = transaction.expirationDate, expirationDate < Date() { continue }
            
            purchasedSubscriptions.insert(transaction.productID)
        }
    }
    
    // Restore purchases (though StoreKit 2 does this automatically)
    func restorePurchases() async throws {
        try await AppStore.sync()
        await refreshPurchasedSubscriptions()
    }
}
