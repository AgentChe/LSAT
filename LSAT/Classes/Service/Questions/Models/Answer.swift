//
//  Answer.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import Foundation

struct Answer: Codable, Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let isCorrect: Bool
}
