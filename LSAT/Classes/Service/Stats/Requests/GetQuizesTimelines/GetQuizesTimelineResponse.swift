//
//  GetQuizesTimelineResponse.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

final class GetQuizesTimelineResponse {
    static func map(from response: Any) -> [ReviewQuizTimeline] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let timelinesArray = data["timeline"] as? [[String: Any]]
        else {
            return []
        }
        
        return timelinesArray.compactMap { timelineJSON -> ReviewQuizTimeline? in
            guard
                let timestamp = timelineJSON["day"] as? TimeInterval,
                let array = timelineJSON["data"] as? [[String: Any]]
            else {
                return nil
            }
            
            let quizes = array.compactMap { quizJSON -> ReviewQuiz? in
                guard
                    let id = quizJSON["id"] as? Int,
                    let type = quizJSON["type"] as? Int,
                    let score = quizJSON["score"] as? Int,
                    let time = quizJSON["time"] as? Int,
                    let averageTime = quizJSON["average_time"] as? Int
                else {
                    return nil
                }
                
                return ReviewQuiz(id: id,
                                  type: type,
                                  score: score,
                                  time: time,
                                  averageTime: averageTime)
            }
            
            let day = Date(timeIntervalSince1970: timestamp)
            
            return ReviewQuizTimeline(day: day,
                                      quizes: quizes)
        }
    }
}
