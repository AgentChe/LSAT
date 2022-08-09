//
//  AgainTestRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 30.05.2022.
//

import Alamofire

struct AgainTestRequest: APIRequestBody {
    let userToken: String
    let userTestId: Int
    
    init(userToken: String, userTestId: Int) {
        self.userToken = userToken
        self.userTestId = userTestId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/testings/again"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "user_test_id": userTestId
        ]
    }
}
