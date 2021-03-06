//
//  Course.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

struct Course {
    let id: Int
    let name: String
    let subTitle: String
    let isMain: Bool
    let sort: Int
}

// MARK: Codable
extension Course: Codable {}
