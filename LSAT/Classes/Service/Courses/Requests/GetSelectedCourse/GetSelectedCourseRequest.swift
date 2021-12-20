//
//  GetSelectedCourseRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 18.11.2021.
//

import Alamofire

struct GetSelectedCourseRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
