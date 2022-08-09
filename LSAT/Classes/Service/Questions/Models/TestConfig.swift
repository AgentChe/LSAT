//
//  TestConfig.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

struct TestConfig {
    let id: Int
    let paid: Bool
}

// MARK: Codable
extension TestConfig: Codable {}

// MARK: Hashable
extension TestConfig: Hashable {}
