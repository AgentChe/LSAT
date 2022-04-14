//
//  SendAnswerResponseMapper.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Foundation

struct SendAnswerResponseMapper {
    static func map(from response: Any) throws -> Bool? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let code = json["_code"] as? Int
        else {
            throw ContentError(.notContent)
        }
        
        guard code == 200 else {
            throw ContentError(.notContent)
        }
        
        guard let isEnd = data["end_of_test"] as? Bool else {
            return nil
        }
        
        return isEnd
    }
}
