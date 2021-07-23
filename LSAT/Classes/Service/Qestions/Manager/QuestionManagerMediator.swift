//
//  QuestionManagerMediator.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.02.2021.
//

import RxCocoa

final class QuestionManagerMediator {
    static let shared = QuestionManagerMediator()
    
    private let testPassedTrigger = PublishRelay<Void>()
    
    private var delegates = [Weak<QuestionManagerDelegate>]()
    
    private init() {}
}

// MARK: API
extension QuestionManagerMediator {
    func testPassed() {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.didTestPassed()
            }
            
            self?.testPassedTrigger.accept(())
        }
    }
}

// MARK: Triggers(Rx)
extension QuestionManagerMediator {
    var rxTestPassed: Signal<Void> {
        testPassedTrigger.asSignal()
    }
}

// MARK: Observer
extension QuestionManagerMediator {
    func add(delegate: QuestionManagerDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<QuestionManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: QuestionManagerMediator) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
