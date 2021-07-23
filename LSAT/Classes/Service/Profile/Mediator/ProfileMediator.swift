//
//  ProfileMediator.swift
//  FNP
//
//  Created by Andrey Chernyshev on 14.07.2021.
//

import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private let changedTestModeTrigger = PublishRelay<TestMode>()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension ProfileMediator {
    func notifyAboutChanged(testMode: TestMode) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didChanged(testMode: testMode)
            }
            
            self?.changedTestModeTrigger.accept(testMode)
        }
    }
}

// MARK: Triggers(Rx)
extension ProfileMediator {
    var rxChangedTestMode: Signal<TestMode> {
        changedTestModeTrigger.asSignal()
    }
}

// MARK: Observer
extension ProfileMediator {
    func add(delegate: ProfileMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<ProfileMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: ProfileMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
