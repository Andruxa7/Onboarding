//
//  OnboardingData.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

// MARK: - OnboardingData
struct OnboardingData: Codable {
    let items: [QuestionItem]
}

// MARK: - QuestionItem
struct QuestionItem: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
