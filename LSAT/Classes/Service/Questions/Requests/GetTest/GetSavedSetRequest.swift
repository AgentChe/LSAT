//
//  GetSavedSetRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 31.05.2022.
//

import Alamofire

struct GetSavedSetRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    private let activeSubscription: Bool
    
    init(userToken: String, courseId: Int, activeSubscription: Bool) {
        self.userToken = userToken
        self.courseId = courseId
        self.activeSubscription = activeSubscription
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/saved"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription
        ]
    }
}
