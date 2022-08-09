//
//  RemoveSavedQuestionRequest.swift
//  Nursing
//
//  Created by Андрей Чернышев on 29.05.2022.
//

import Alamofire

struct RemoveSavedQuestionRequest: APIRequestBody {
    private let userToken: String
    private let questionId: Int
    
    init(userToken: String, questionId: Int) {
        self.userToken = userToken
        self.questionId = questionId
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/remove"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
         [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "question_id": questionId
        ]
    }
}
