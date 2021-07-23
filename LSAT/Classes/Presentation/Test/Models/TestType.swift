//
//  TestType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 13.02.2021.
//

import Foundation

enum TestType {
    case get(testId: Int?)
    case tenSet
    case failedSet
    case qotd
    case randomSet
}
