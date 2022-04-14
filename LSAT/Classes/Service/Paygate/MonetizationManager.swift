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

final class MonetizationManager: MonetizationManagerProtocol {
    struct Constants {
        static let cachedMonetizationConfig = "monetization_manager_core_cached_monetization_config"
    }
    
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension MonetizationManager {
    // С 42 (Nursing) билда монетизация всегда suggest
    func getMonetizationConfig() -> MonetizationConfig? {
        .suggest
//        guard let rawValue = UserDefaults.standard.string(forKey: Constants.cachedMonetizationConfig) else {
//            return nil
//        }
//
//        return MonetizationConfig(rawValue: rawValue)
    }
    
    // С 42 (Nursing) билда монетизация всегда suggest
    func rxRetrieveMonetizationConfig(forceUpdate: Bool) -> Single<MonetizationConfig?> {
        .deferred { .just(.suggest) }
//        if forceUpdate {
//            return loadConfig()
//        } else {
//            return .deferred { [weak self] in
//                guard let this = self else {
//                    return .never()
//                }
//
//                return .just(this.getMonetizationConfig())
//            }
//        }
    }
}

// MARK: Private
private extension MonetizationManager {
    func loadConfig() -> Single<MonetizationConfig?> {
        let request = GetMonetizationConfigRequest(userToken: SessionManagerCore().getSession()?.userToken,
                                                   version: UIDevice.appVersion ?? "1",
                                                   appAnonymousId: SDKStorage.shared.applicationAnonymousID)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetMonetizationResponseMapper.map(from: $0) }
            .catchAndReturn(nil)
            .flatMap { [weak self] config -> Single<MonetizationConfig?> in
                guard let this = self else {
                    return .never()
                }
                
                return this.store(config: config)
            }
    }
    
    func store(config: MonetizationConfig?) -> Single<MonetizationConfig?> {
        Single<MonetizationConfig?>
            .create { event in
                guard let rawValue = config?.rawValue else {
                    event(.success(config))
                    return Disposables.create()
                }
        
                UserDefaults.standard.setValue(rawValue, forKey: Constants.cachedMonetizationConfig)
                
                event(.success(config))
                
                return Disposables.create()
            }
    }
}
