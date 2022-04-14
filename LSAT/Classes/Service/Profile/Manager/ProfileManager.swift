//
//  ProfileManager.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import RxSwift

protocol ProfileManager {
    // MARK: Study
    func set(level: Int?,
             assetsPreferences: [Int]?,
             testMode: Int?,
             examDate: String?,
             testMinutes: Int?,
             testNumber: Int?,
             testWhen: [Int]?,
             notificationKey: String?) -> Single<Void>
    
    // MARK: Test Mode
    func obtainTestMode() -> Single<TestMode?>
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
}
