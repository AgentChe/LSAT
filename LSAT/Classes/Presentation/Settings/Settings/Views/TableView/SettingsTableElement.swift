//
//  SettingsTableElement.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import Foundation

enum SettingsTableElement {
    case offset(CGFloat)
    case unlockPremium
    case premium(SettingsPremium)
    case exam(SettingsExam)
    case study(SettingsStudy)
    case community(SettingsCommunity)
    case support
}

struct SettingsPremium {
    let title: String
    let memberSince: String
    let validTill: String
    let userId: Int?
}

struct SettingsExam {
    let course: Course?
    let examDate: Date?
    let resetProgressActivity: Bool
}

struct SettingsStudy {
    let testMode: TestMode?
    let vibration: Bool
}

struct SettingsCommunity {
    let communityUrl: String?
}
