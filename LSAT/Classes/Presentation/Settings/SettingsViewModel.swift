//
//  SettingsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    private lazy var coursesManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    
    lazy var sections = makeSections()
    lazy var activityIndicator = makeActivityIndicator()

    private lazy var courseActivityIndicator = RxActivityIndicator()
    private lazy var modeActivityIndicator = RxActivityIndicator()
    private lazy var referencesActivityIndicator = RxActivityIndicator()
}

// MARK: Private
private extension SettingsViewModel {
    func makeSections() -> Driver<[SettingsTableSection]> {
        let activeSubscription = self.activeSubscription()
        let course = self.course()
        let mode = self.mode()
        let references = self.makeReferencesSection()
        
        return Driver
            .combineLatest(activeSubscription, course, mode, references) { activeSubscription, course, mode, references -> [SettingsTableSection] in
                var sections = [SettingsTableSection]()
                
                if !activeSubscription {
                    sections.append(.unlockPremium)
                }
                
                sections.append(contentsOf: [
                    .selectedCourse(course),
                    .mode(mode)
                ])
                
                if let ref = references {
                    sections.append(ref)
                }
                
                sections.append(.links)
                
                return sections
            }
    }
    
    func activeSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
    
    func course() -> Driver<Course> {
        coursesManager
            .retrieveSelectedCourse()
            .trackActivity(courseActivityIndicator)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func mode() -> Driver<TestMode> {
        let initial = profileManager
            .obtainTestMode()
            .trackActivity(modeActivityIndicator)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
        
        let updated = ProfileMediator.shared
            .rxChangedTestMode
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                initial, updated
            )
    }
    
    func makeReferencesSection() -> Driver<SettingsTableSection?> {
        coursesManager
            .retrieveReferences(forceUpdate: false)
            .map { references -> SettingsTableSection? in
                references.isEmpty ? nil : .references
            }
            .trackActivity(referencesActivityIndicator)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeActivityIndicator() -> Driver<Bool> {
        Driver
            .combineLatest(
                courseActivityIndicator,
                modeActivityIndicator,
                referencesActivityIndicator
            ) { $0 || $1 || $2 }
        }
}
