//
//  StatsMediator.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.05.2022.
//

import RxSwift
import RxCocoa

protocol StatsMediatorDelegate: AnyObject {
    func statsMediatorDidResetedStats()
}

final class StatsMediator {
    static let shared = StatsMediator()
    
    private let resetedStatsTrigger = PublishRelay<Void>()
    
    private var delegates = [Weak<StatsMediatorDelegate>]()
    
    private init() {}
}

// MARK: Public
extension StatsMediator {
    func notifyAboutResetedStats() {
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach {
                $0.weak?.statsMediatorDidResetedStats()
            }
            
            self?.resetedStatsTrigger.accept(Void())
        }
    }
}

// MARK: Triggers(Rx)
extension StatsMediator {
    var resetedStats: Signal<Void> {
        resetedStatsTrigger.asSignal()
    }
}

// MARK: Observer
extension StatsMediator {
    func add(delegate: StatsMediatorDelegate) {
        let weakly = delegate as AnyObject
        delegates.append(Weak<StatsMediatorDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }

    func remove(delegate: StatsMediatorDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === delegate }) {
            delegates.remove(at: index)
        }
    }
}
