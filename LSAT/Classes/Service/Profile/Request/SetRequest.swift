//
//  SetRequest.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import Alamofire

struct SetRequest: APIRequestBody {
    private let userToken: String
    private let examDate: String?
    private let courseId: Int?
    private let testMode: Int?
    private let testMinutes: Int?
    private let testNumber: Int?
    private let testWhen: [Int]?
    private let notificationKey: String?
    
    init(userToken: String,
         examDate: String? = nil,
         courseId: Int? = nil,
         testMode: Int? = nil,
         testMinutes: Int? = nil,
         testNumber: Int? = nil,
         testWhen: [Int]? = nil,
         notificationKey: String? = nil) {
        self.userToken = userToken
        self.examDate = examDate
        self.courseId = courseId
        self.testMode = testMode
        self.testMinutes = testMinutes
        self.testNumber = testNumber
        self.testWhen = testWhen
        self.notificationKey = notificationKey
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
        
        if let examDate = self.examDate {
            params["exam_date"] = examDate
        }
        
        if let courseId = courseId {
            params["current_application_course_id"] = courseId
        }
        
        if let testMode = self.testMode {
            params["test_mode"] = testMode
        }
        
        if let testMinutes = self.testMinutes {
            params["test_minutes"] = testMinutes
        }
        
        if let testNumber = self.testNumber {
            params["test_number"] = testNumber
        }
        
        if let testWhen = self.testWhen {
            params["test_when"] = testWhen
        }
        
        if let notificationKey = self.notificationKey {
            params["notification_key"] = notificationKey
        }
        
        return params
    }
}
