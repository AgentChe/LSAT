//
//  ProfileMediator.swift
//  FNP
//
//  Created by Andrey Chernyshev on 14.07.2021.
//

import RxCocoa

protocol ProfileMediatorDelegate: AnyObject {
    func prodileMediatorDidChanged(dateOfExam: Date)
    func prodileMediatorDidChanged(course: Course)
    func prodileMediatorDidChanged(testMode: TestMode)
    func prodileMediatorDidChanged(testMinutes: Int)
}

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private let changedDateOfExamTrigger = PublishRelay<Date>()
    private let changedCourseTrigger = PublishRelay<Course>()
    private let changedTestModeTrigger = PublishRelay<TestMode>()
    private let changedTestMinutesTrigger = PublishRelay<Int>()
    
    private var delegates = [Weak<ProfileMediatorDelegate>]()
    
    private init() {}
}

// MARK: API
extension ProfileMediator {
    func notifyAboutChanged(dateOfExam: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(dateOfExam: dateOfExam)
            }
            
            self?.changedDateOfExamTrigger.accept(dateOfExam)
        }
    }
    
    func notifyAboutChanged(course: Course) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(course: course)
            }
            
            self?.changedCourseTrigger.accept(course)
        }
    }
    
    func notifyAboutChanged(testMode: TestMode) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(testMode: testMode)
            }
            
            self?.changedTestModeTrigger.accept(testMode)
        }
    }
    
    func notifyAboutChanged(testMinutes: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.prodileMediatorDidChanged(testMinutes: testMinutes)
            }
            
            self?.changedTestMinutesTrigger.accept(testMinutes)
        }
    }
}

// MARK: Triggers(Rx)
extension ProfileMediator {
    var changedDateOfExam: Signal<Date> {
        changedDateOfExamTrigger.asSignal()
    }
    
    var changedCourse: Signal<Course> {
        changedCourseTrigger.asSignal()
    }
    
    var changedTestMode: Signal<TestMode> {
        changedTestModeTrigger.asSignal()
    }
    
    var changedTestMinutes: Signal<Int> {
        changedTestMinutesTrigger.asSignal()
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
