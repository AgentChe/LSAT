//
//  MonetizationManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 27.11.2020.
//

import RxSwift

protocol MonetizationManagerProtocol {
    func getMonetizationConfig() -> MonetizationConfig?
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?>
}

final class MonetizationManager: MonetizationManagerProtocol {}

// MARK: Public
extension MonetizationManager {
    // С 42 билда монетизация всегда suggest
    func getMonetizationConfig() -> MonetizationConfig? {
        .suggest
    }
    
    // С 42 билда монетизация всегда suggest
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?> {
        .deferred { .just(.suggest) }
    }
}
