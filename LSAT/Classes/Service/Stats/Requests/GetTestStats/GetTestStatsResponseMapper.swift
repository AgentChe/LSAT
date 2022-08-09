//
//  GetTestStatsResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Foundation

struct GetTestStatsResponseMapper {
    static func map(from response: Any) -> TestStats? {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey),
            let data = json["_data"] as? [String: Any],
            let correctNumber = data["correct_number"] as? Int,
            let incorrectNumber = data["incorrect_number"] as? Int,
            let userTime = data["user_time"] as? String,
            let userScore = data["user_score"] as? Int,
            let communityTime = data["community_time"] as? String,
            let communityScore = data["community_score"] as? Int,
            let questions = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let elements = questions.compactMap { elementJSON -> Review? in
            guard
                let questionJSON = elementJSON["question"] as? [String: Any],
                let question = QuestionMapper.map(from: questionJSON),
                let isCorrectly = elementJSON["correctly_answered"] as? Bool,
                let userAnswersIds = elementJSON["user_answers"] as? [Int]
            else {
                return nil
            }
            
            return Review(question: question,
                          isCorrectly: isCorrectly,
                          userAnswersIds: userAnswersIds)
        }
        
        return TestStats(
            correctNumbers: correctNumber,
            incorrectNumbers: incorrectNumber,
            userTime: userTime,
            userScore: userScore,
            communityTime: communityTime,
            communityScore: communityScore,
            questions: elements
        )
    }
}
