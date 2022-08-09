//
//  TestType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 13.02.2021.
//

enum TestType {
    case get(testId: Int?)
    case tenSet
    case failedSet
    case qotd
    case randomSet
    case saved
    case timed(minutes: Int)
}

// MARK: Public
extension TestType {
    func isQotd() -> Bool {
        guard case .qotd = self else {
            return false
        }
        
        return true
    }
}
