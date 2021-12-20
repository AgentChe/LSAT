//
//  SplashViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, course, paygate
    }
    
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var monetizationManager = MonetizationManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    
    func step() -> Driver<Step> {
        library()
            .andThen(makeStep())
            .asDriver(onErrorDriveWith: .empty())
    }
    
    /// Вызывается в методе делегата PaygateViewControllerDelegate для определения, какой экран открыть после закрытия пейгейта. Отличается от makeStep тем, что не учитывает повторное открытие пейгейта.
    func stepAfterPaygateClosed() -> Step {
        guard OnboardingViewController.wasViewed() else {
            return .onboarding
        }
        
        if coursesManager.getSelectedCourse() != nil {
            return .course
        }
        
        return .course
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Completable {
        Completable
            .zip(
                monetizationManager
                    .rxRetrieveMonetizationConfig(forceUpdate: true)
                    .catchAndReturn(nil)
                    .asCompletable(),
                
                coursesManager
                    .retrieveReferences(forceUpdate: true)
                    .catchAndReturn([])
                    .asCompletable()
            )
    }
    
    func makeStep() -> Single<Step> {
        coursesManager
            .retrieveSelectedCourse(forceUpdate: true)
            .catchAndReturn(nil)
            .map { [weak self] selectedCourse -> Step in
                guard let self = self else {
                    return .onboarding
                }
                
                if selectedCourse != nil {
                    return .course
                }
                
                guard OnboardingViewController.wasViewed() else {
                    return .onboarding
                }
                
                if self.needPayment() {
                    return .paygate
                }
                
                return .course
            }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.getSession()?.activeSubscription ?? false
        return !activeSubscription
    }
}
