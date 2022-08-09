//
//  GetProfileResponseMapper.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import RxSwift

final class GetProfileResponseMapper {
    static func map(from response: Any) -> Profile? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let testMode = testMode(data)
        let testMinutes = data["daily_goal"] as? Int
        let examDate = examDate(data)
        let course = course(data)
        let communityUrl = data["community_url"] as? String
        
        return Profile(testMode: testMode,
                       testMinutes: testMinutes,
                       examDate: examDate,
                       selectedCourse: course,
                       communityUrl: communityUrl)
    }
}

// MARK: Private
private extension GetProfileResponseMapper {
    static func testMode(_ json: [String: Any]) -> TestMode? {
        guard let testModeCode = json["test_mode"] as? Int else {
            return nil
        }
        
        return TestMode(code: testModeCode)
    }
    
    static func examDate(_ json: [String: Any]) -> Date? {
        guard let timeInterval = json["exam_date"] as? TimeInterval else {
            return nil
        }
        
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    static func course(_ json: [String: Any]) -> Course? {
        guard
            let courseJSON = json["current_course"] as? [String: Any],
            let id = courseJSON["id"] as? Int,
            let name = courseJSON["name"] as? String,
            let subTitle = courseJSON["sub"] as? String,
            let isMain = courseJSON["main"] as? Bool,
            let sort = courseJSON["sort"] as? Int
        else {
            return nil
        }
        
        return Course(id: id,
                      name: name,
                      subTitle: subTitle,
                      isMain: isMain,
                      sort: sort)
    }
}
