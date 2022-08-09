//
//  OnboardingViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case paygateBlock
        case paygateSuggest
        case nextScreen
    }

    private lazy var sessionManager = SessionManager()
    private lazy var monetizationManager = MonetizationManager()

    func whatNext() -> Step {
        let hasActiveSubscription = sessionManager.getSession()?.activeSubscription ?? false

        if hasActiveSubscription {
            return .nextScreen
        }

        guard let config = monetizationManager.getMonetizationConfig() else {
            return .nextScreen
        }

        switch config {
        case .block:
            return .paygateBlock
        case .suggest:
            return .paygateSuggest
        }
    }
}
