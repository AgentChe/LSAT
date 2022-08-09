//
//  ReportReason.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

enum ReportReason {
    case answerIsWrong, caughtTypo, confusing, notWorking
}

// MARK: Public
extension ReportReason {
    func code() -> Int {
        switch self {
        case .answerIsWrong:
            return 1
        case .caughtTypo:
            return 2
        case .confusing:
            return 3
        case .notWorking:
            return 4
        }
    }
}
