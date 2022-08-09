//
//  TestStatsProgressElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct TestStatsProgressElement {
    let correctNumbers: Int
    let incorrectNumbers: Int
    let percent: Int
}

extension TestStatsProgressElement {
    init(stats: TestStats) {
        correctNumbers = stats.correctNumbers
        incorrectNumbers = stats.incorrectNumbers
        percent = stats.userScore
    }
}
