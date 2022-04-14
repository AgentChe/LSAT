//
//  Question.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct Test: Codable, Hashable {
    let paid: Bool
    let userTestId: Int
    let questions: [Question]
}

struct Question: Codable, Hashable {
    let id: Int
    let image: URL?
    let video: URL?
    let question: String
    let questionHtml: String
    let answers: [Answer]
    let multiple: Bool
    let explanation: String?
    let explanationHtml: String?
    let media: [URL]
    let isAnswered: Bool
    let reference: String?
}

struct Answer: Codable, Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let isCorrect: Bool
}
