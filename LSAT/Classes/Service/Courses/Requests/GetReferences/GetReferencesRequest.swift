//
//  GetReferencesRequest.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import Alamofire

struct GetReferencesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domainUrl + "/api/courses/references"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
}
