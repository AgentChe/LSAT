//
//  SetSelectCourseRequest.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 18.11.2021.
//

import Alamofire

struct SetSelectCourseRequest: APIRequestBody {
    let userToken: String
    let courseId: Int
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "current_application_course_id": courseId,
            "platform": 1
        ]
    }
}
