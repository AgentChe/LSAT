//
//  GetTestResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Foundation

struct GetTestResponseMapper {
    static func map(from response: Any) throws -> Test? {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey),
            let code = json["_code"] as? Int
        else { return nil }
        
        guard code == 200 else {
            throw NSError(domain: "\(type(of: self))", code: code, userInfo: [NSLocalizedDescriptionKey : (json["_msg"] as? String) ?? ""])
        }
        
        guard
            let data = json["_data"] as? [String: Any],
            let paid = data["paid"] as? Bool,
            let userTestId = data["user_test_id"] as? Int,
            let questionsJSON = data["questions"] as? [[String: Any]]
        else {
            return nil
        }
        
        let questions: [Question] = Self.map(from: questionsJSON)
        
        guard !questions.isEmpty else { return nil }
        
        return Test(
            paid: paid,
            userTestId: userTestId,
            questions: questions
        )
    }
}

// MARK: Private
private extension GetTestResponseMapper {
    static func map(from questions: [[String: Any]]) -> [Question] {
        questions.compactMap { restJSON -> Question? in
            guard
                let id = restJSON["id"] as? Int,
                let multiple = restJSON["multiple"] as? Bool,
                let isAnswered = restJSON["answered"] as? Bool,
                let answersJSON = restJSON["answers"] as? [[String: Any]]
            else {
                return nil
            }
            
            let explanation = restJSON["explanation"] as? String
            let explanationHtml = restJSON["explanation_html"] as? String
            
            let answers: [Answer] = Self.map(from: answersJSON)
            guard !answers.isEmpty else { return nil }
            
            let image = (restJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let video = (restJSON["video"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let question = restJSON["question"] as? String ?? ""
            let questionHtml = restJSON["question_html"] as? String ?? ""
            
            let reference = restJSON["reference"] as? String
            
            return Question(
                id: id,
                image: URL(string: image),
                video: URL(string: video),
                question: question,
                questionHtml: questionHtml,
                answers: answers,
                multiple: multiple,
                explanation: explanation,
                explanationHtml: explanationHtml,
                isAnswered: isAnswered,
                reference: reference
            )
        }
    }
    
    static func map(from answers: [[String: Any]]) -> [Answer] {
        answers.compactMap { restJSON -> Answer? in
            guard
                let id = restJSON["id"] as? Int,
                let correct = restJSON["correct"] as? Bool
            else {
                return nil
            }
            
            let answer = restJSON["answer"] as? String
            let answerHtml = restJSON["answer_html"] as? String
            
            let image = (restJSON["image"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            return Answer(id: id,
                          answer: answer,
                          answerHtml: answerHtml,
                          image: URL(string: image),
                          isCorrect: correct)
        }
    }
}
