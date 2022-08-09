//
//  Session.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RushSDK

struct Session: Codable {
    let userId: Int?
    let userToken: String?
    let activeSubscription: Bool
    let usedProducts: [String]
    let accessValidTill: String?
    let userSince: String?
}

// MARK: Make
extension Session {
    init(response: ReceiptValidateResponse) {
        self.userId = response.userId
        self.userToken = response.userToken
        self.activeSubscription = response.activeSubscription
        self.usedProducts = response.usedProducts
        self.accessValidTill = response.accessValidTill
        self.userSince = response.userSince
    }
}
