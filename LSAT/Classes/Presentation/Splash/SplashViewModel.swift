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
        case onboarding, courses, course, paygate
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
        
        return .courses
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
    
    func makeStep() -> Observable<Step> {
        guard OnboardingViewController.wasViewed() else {
            return .deferred { .just(.onboarding) }
        }
        
        if needPayment() {
            return .deferred { .just(.paygate) }
        }
        
        if coursesManager.getSelectedCourse() != nil {
            return .deferred { .just(.course) }
        }
        
        return .deferred { .just(.courses) }
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.getSession()?.activeSubscription ?? false
        return !activeSubscription
    }
}
