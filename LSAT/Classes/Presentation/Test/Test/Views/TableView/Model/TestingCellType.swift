//
//  TestingCellType.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import Foundation

enum TestingCellType {
    case content([QuestionContentType])
    case question(String, html: String, TextSize)
    case answers([PossibleAnswerElement], TextSize)
    case result([AnswerResultElement], TextSize)
    case explanationTitle
    case explanationText(String, html: String)
    case explanationImage(URL)
    case reference(String)
}
