//
//  TestElement.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

struct PossibleAnswerElement: Hashable {
    let id: Int
    let answer: String?
    let answerHtml: String?
    let image: URL?
}

struct AnswerResultElement {
    let answer: String?
    let answerHtml: String?
    let image: URL?
    let state: AnswerState
}

enum AnswerState {
    case initial, correct, warning, error
}

struct QuestionElement {
    let id: Int
    let elements: [TestingCellType]
    let isMultiple: Bool
    let index: Int
    var isAnswered: Bool
    let questionsCount: Int
    var isSaved: Bool
}

struct AnswerElement {
    let questionId: Int
    let answerIds: [Int]
    let isMultiple: Bool
}
