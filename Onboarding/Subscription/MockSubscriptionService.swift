//
//  MockSubscriptionService.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Protocol to simulate working with StoreKit
protocol SubscriptionServiceProtocol {
    func fetchProducts() async throws -> [SubscriptionProduct]
    func purchase(product: SubscriptionProduct) async throws -> PurchaseResult
    func checkSubscriptionStatus() async -> Bool
    func restorePurchases() async throws -> Bool
}

// MARK: - Models for working with subscriptions
struct SubscriptionProduct {
    let id: String
    let name: String
    let description: String
    let price: Decimal
    let priceFormatted: String
    let trialPeriod: String?
    let subscriptionPeriod: String
}

enum PurchaseResult {
    case success
    case userCancelled
    case pending
    case error(String)
}

enum SubscriptionError: Error {
    case productNotFound
    case purchaseCancelled
    case networkError
    case pendingPurchase
    case unknown
    
    var description: String {
        switch self {
        case .productNotFound:
            return "Product not found in App Store"
        case .purchaseCancelled:
            return "The purchase was cancelled"
        case .networkError:
            return "Error connecting to App Store"
        case .pendingPurchase:
            return "Additional action required"
        case .unknown:
            return "Unknown error"
        }
    }
}

// MARK: - Implementation of a mock subscription service
class MockSubscriptionService: SubscriptionServiceProtocol {
    
    private let simulatedNetworkDelay: TimeInterval = 1.5
    
    private var shouldSimulateError = false
    
    private let mockProducts = [
        SubscriptionProduct(
            id: "com.yourapp.premium.weekly",
            name: "Premium Subscription",
            description: "Full access to all application functions",
            price: 6.99,
            priceFormatted: "$6.99",
            trialPeriod: "7 days",
            subscriptionPeriod: "weekly"
        ),
        SubscriptionProduct(
            id: "com.yourapp.premium.monthly",
            name: "Premium Monthly",
            description: "Full access to all application functions",
            price: 19.99,
            priceFormatted: "$19.99",
            trialPeriod: "7 days",
            subscriptionPeriod: "monthly"
        )
    ]
    
    private enum DemoResult {
        case success, cancel, pending, error
    }
    
    private var demoResult: DemoResult = .success
    
    func setDemoResult(_ result: String) {
        switch result.lowercased() {
        case "success": demoResult = .success
        case "cancel": demoResult = .cancel
        case "pending": demoResult = .pending
        case "error": demoResult = .error
        default: demoResult = .success
        }
    }
    
    func fetchProducts() async throws -> [SubscriptionProduct] {
        try await Task.sleep(nanoseconds: UInt64(simulatedNetworkDelay * 1_000_000_000))
        
        if shouldSimulateError {
            throw SubscriptionError.networkError
        }
        
        return mockProducts
    }
    
    func purchase(product: SubscriptionProduct) async throws -> PurchaseResult {
        try await Task.sleep(nanoseconds: UInt64(simulatedNetworkDelay * 1_000_000_000))
        
        switch demoResult {
        case .success:
            UserDefaults.standard.set(true, forKey: "isPremiumActive")
            UserDefaults.standard.set(Date(), forKey: "premiumActivationDate")
            UserDefaults.standard.set(product.id, forKey: "activePremiumProductID")
            
            return .success
            
        case .cancel:
            throw SubscriptionError.purchaseCancelled
            
        case .pending:
            return .pending
            
        case .error:
            throw SubscriptionError.networkError
        }
    }
    
    func checkSubscriptionStatus() async -> Bool {
        do {
            try await Task.sleep(nanoseconds: UInt64(0.5 * 1_000_000_000))
        } catch {
            // Ignoring the error when canceling a task
        }
        
        let isPremiumActive = UserDefaults.standard.bool(forKey: "isPremiumActive")
        
        if isPremiumActive {
            if let activationDate = UserDefaults.standard.object(forKey: "premiumActivationDate") as? Date {
                // For demonstration purposes: subscription expires in 7 days
                let expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: activationDate)
                return expirationDate ?? Date() > Date()
            }
        }
        
        return isPremiumActive
    }
    
    func restorePurchases() async throws -> Bool {
        try await Task.sleep(nanoseconds: UInt64(simulatedNetworkDelay * 1_000_000_000))
        
        if shouldSimulateError {
            throw SubscriptionError.networkError
        }
        
        return UserDefaults.standard.bool(forKey: "isPremiumActive")
    }
}
