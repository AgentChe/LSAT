//
//  GetOnboardingSetRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.02.2022.
//

import Alamofire

struct GetOnboardingSetRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/testings/onboarding_set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": 1,
            "platform": 1
        ]
    }
}
