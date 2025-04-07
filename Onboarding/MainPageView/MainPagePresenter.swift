//
//  MainPagePresenter.swift
//  Onboarding
//
//  Created by Andrii Stetsenko on 07.04.2025.
//

import Foundation

protocol MainPagePresenterProtocol {
    func onAppear()
}

class MainPagePresenter: MainPagePresenterProtocol {
    private let onboardingUseCase: OnboardingUseCaseProtocol = OnboardingUseCase()
    weak var view: MainPageViewControllerDisplayLogic?
    
    init(view: MainPageViewControllerDisplayLogic) {
        self.view = view
    }
    
    func onAppear() {
        Task {
            do {
                let questions = try await onboardingUseCase.loadOnboarding()
                Task { @MainActor in
                    view?.showOnboarding(questions: questions)
                }
            } catch {
                print(error)
            }
        }
    }
}
