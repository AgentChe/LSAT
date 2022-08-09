//
//  QuestionMediator.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.02.2021.
//

import RxCocoa

protocol QuestionMediatorDelegate: AnyObject {
    func questionMediatorDidTestPassed()
    func questionMediatorDidTestClosed(element: TestFinishElement)
}

final class QuestionMediator {
    static let shared = QuestionMediator()
    
    private let testPassedTrigger = PublishRelay<Void>()
    private let testClosedTrigger = PublishRelay<TestFinishElement>()
    
    private var delegates = [Weak<QuestionMediatorDelegate>]()
    
    private init() {}
}

// MARK: Public
extension QuestionMediator {
    func notidyAboutTestPassed() {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.questionMediatorDidTestPassed()
            }
            
            self?.testPassedTrigger.accept(())
        }
    }
    
    func notifyAboudTestClosed(with element: TestFinishElement) {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.questionMediatorDidTestClosed(element: element)
            }
            
            self?.testClosedTrigger.accept(element)
        }
    }
}

// MARK: Triggers(Rx)
extension QuestionMediator {
    var testPassed: Signal<Void> {
        testPassedTrigger.asSignal()
    }
    
    var testClosed: Signal<TestFinishElement> {
        testClosedTrigger.asSignal()
    }
}

// MARK: Observer
extension QuestionMediator {
    func add(delegate: QuestionMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<QuestionMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: QuestionMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
