//
//  GetTestStatsRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import Alamofire

struct GetTestStatsRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    let userTestId: Int
    let peek: Bool
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/review/test"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_test_id": userTestId,
            "peek": peek
        ]
    }
}
