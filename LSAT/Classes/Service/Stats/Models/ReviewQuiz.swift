//
//  ReviewQuiz.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

struct ReviewQuiz: Codable, Hashable {
    let id: Int
    let type: Int
    let score: Int
    let time: Int
    let averageTime: Int
}
