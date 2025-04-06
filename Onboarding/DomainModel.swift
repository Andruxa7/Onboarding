//
//  DomainModel.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

// MARK: - DomainModel
struct Question: Equatable {
    let id: Int
    let questionText: String
    let possibleAnswers: [String]
}

// Converter from Codable в Domain Model
extension QuestionItem {
    func toDomain() -> Question {
        return Question(id: id, questionText: question, possibleAnswers: answers)
    }
}

// Converter for array
extension OnboardingData {
    func toDomain() -> [Question] {
        return items.map { $0.toDomain() }
    }
}
