//
//  GetReviewResponse.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

final class GetReviewResponse {
    static func map(from response: Any) -> [Review] {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey),
            let data = json["_data"] as? [[String: Any]]
        else {
            return []
        }
    
        return data.compactMap { reviewJSON -> Review? in
            guard
                let questionJSON = reviewJSON["question"] as? [String: Any],
                let question = QuestionMapper.map(from: questionJSON),
                let isCorrectly = reviewJSON["correctly_answered"] as? Bool,
                let userAnswersIds = reviewJSON["user_answers"] as? [Int]
            else {
                return nil
            }
            
            return Review(question: question,
                          isCorrectly: isCorrectly,
                          userAnswersIds: userAnswersIds)
        }
    }
}
