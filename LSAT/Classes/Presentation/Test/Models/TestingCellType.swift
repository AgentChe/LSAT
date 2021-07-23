//
//  TestingCellType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

enum TestingCellType {
    case questionsProgress(String)
    case content([QuestionContentType])
    case question(String, html: String)
    case answers([PossibleAnswerElement])
    case result([AnswerResultElement])
    case explanation(String, html: String)
    case reference(String)
}
