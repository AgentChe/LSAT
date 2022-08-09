//
//  ReportRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import Alamofire

struct ReportRequest: APIRequestBody {
    let userToken: String
    let questionId: Int
    let userId: Int?
    let reason: Int
    let email: String?
    let comment: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/report"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "test_question_id": questionId,
            "reason": reason,
            "comment": comment
        ]
        
        if let userId = userId {
            params["user_id"] = userId
        }
        
        if let email = email {
            params["email"] = email
        }
        
        return params
    }
}
