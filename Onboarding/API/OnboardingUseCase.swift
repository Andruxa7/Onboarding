//
//  OnboardingUseCase.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

protocol OnboardingUseCaseProtocol {
    func loadOnboarding() async throws -> [Question]
}

class OnboardingUseCase: OnboardingUseCaseProtocol {
    func loadOnboarding() async throws -> [Question] {
        return try await OnboardingService
            .loadOnboardingData()
            .toDomain()
    }
}
