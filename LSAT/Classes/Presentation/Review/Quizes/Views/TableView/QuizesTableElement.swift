//
//  QuizesTableElement.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

import CoreGraphics

enum QuizesTableElement {
    case offset(CGFloat)
    case day(Date)
    case quiz(QuizesTableQuiz)
}

struct QuizesTableQuiz {
    let id: Int
    let type: TestType
    let score: Int
    let time: Int
    let averageTime: Int
    
    init?(quiz: ReviewQuiz) {
        switch quiz.type {
        case 1:
            type = .get(testId: nil)
        case 2:
            type = .tenSet
        case 3:
            type = .failedSet
        case 4:
            type = .randomSet
        case 5:
            type = .qotd
        case 6:
            type = .saved
        case 7:
            type = .timed(minutes: 0)
        default:
            return nil
        }
        
        id = quiz.id
        score = quiz.score
        time = quiz.time
        averageTime = quiz.averageTime
    }
}
