//
//  ResetStatsRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.05.2022.
//

import Alamofire

struct ResetStatsRequest: APIRequestBody {
    let userToken: String
    let courseId: Int

    var url: String {
        GlobalDefinitions.domainUrl + "/api/stats/reset"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "platform": 1
        ]
    }
}
