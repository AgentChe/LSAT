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
        case onboarding, course, paygate, courses
    }
    
    lazy var validationComplete = PublishRelay<Void>()
    lazy var courseSelected = PublishRelay<Void>()
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var monetizationManager = MonetizationManager()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    private lazy var paygateManager = PaygateManager()
    private lazy var questionManager = QuestionManagerCore()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    func step() -> Driver<Step> {
        let initial = validationComplete
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.library()
            }
            .flatMap { [weak self] _ -> Observable<Step> in
                guard let self = self else {
                    return .never()
                }
                
                return self.makeInitialStep()
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let afterCourseSelected = courseSelected
            .compactMap { [weak self] _ -> Step? in
                guard let self = self else {
                    return nil
                }
                
                return self.needPayment() ? .paygate : .course
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver.merge(initial, afterCourseSelected)
    }
}

// MARK: Private
private extension SplashViewModel {
    func library() -> Observable<Void> {
        func source() -> Single<Void> {
            Single
                .zip(
                    monetizationManager
                        .rxRetrieveMonetizationConfig(forceUpdate: true),
                    
                    coursesManager
                        .retrieveReferences(forceUpdate: true),
                    
                    coursesManager
                        .retrieveCourses(forceUpdate: true),
                    
                    paygateManager
                        .retrievePaygate(forceUpdate: true)
                )
                .map { _ in Void() }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
    }
    
    func makeInitialStep() -> Observable<Step> {
        func source() -> Single<Step> {
            coursesManager
                .retrieveSelectedCourse(forceUpdate: true)
                .map { [weak self] selectedCourse -> Step in
                    guard let self = self else {
                        return .onboarding
                    }
                    
                    // Если у пользователя есть выбранный курс, значит он уже проходил онбординг (в вебе или андроиде, например). Смотрим, есть ли платный доступ и открываем либо пейгейт, либо главный экран.
                    if selectedCourse != nil {
                        return self.needPayment() ? .paygate : .course
                    }
                    
                    // Если пользователь не выбирал курс и не проходил онбординг, отправляем его на онбординг.
                    if !OnboardingViewController.wasViewed() {
                        return .onboarding
                    }
                    
                    // Если пользователь проходил онбординг, но не имеет выбранный курс, открываем экран для выбора курса.
                    return .courses
                }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
    }
    
    func needPayment() -> Bool {
        let activeSubscription = sessionManager.getSession()?.activeSubscription ?? false
        return !activeSubscription
    }
}
