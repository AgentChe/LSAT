//
//  TestStatsDescriptionElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStatsDescriptionElement {
    let userTime: String
    let communityTime: String
    let communityScore: Int
}

extension TestStatsDescriptionElement {
    init(stats: TestStats) {
        userTime = stats.userTime
        communityTime = stats.communityTime
        communityScore = stats.communityScore
    }
}
