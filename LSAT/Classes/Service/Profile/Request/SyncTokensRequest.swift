//
//  SyncTokensRequest.swift
//  NCLEX
//
//  Created by Андрей Чернышев on 03.02.2022.
//

import Alamofire

struct SyncTokensRequest: APIRequestBody {
    let oldToken: String
    let newToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "user_token": newToken,
            "_user_token": oldToken,
            "platform": 1
        ]
    }
}
