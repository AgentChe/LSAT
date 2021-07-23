//
//  Reference.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

struct Reference {
    let title: String
    let details: String
    let link: String?
}

// MARK: Codable
extension Reference: Codable {}

// MARK: Hashable
extension Reference: Hashable {}
