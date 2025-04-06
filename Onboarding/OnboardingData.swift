//
//  OnboardingData.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

struct OnboardingData: Codable {
    let items: [QuestionItem]
}

struct QuestionItem: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
