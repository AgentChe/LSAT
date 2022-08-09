//
//  ReviewQuizTimeline.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

struct ReviewQuizTimeline: Codable, Hashable {
    let day: Date
    let quizes: [ReviewQuiz]
}
