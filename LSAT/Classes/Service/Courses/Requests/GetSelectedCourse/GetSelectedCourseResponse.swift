//
//  GetSelectedCourseResponse.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 18.11.2021.
//

final class GetSelectedCourseResponse {
    static func map(from response: Any) throws -> Course? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let code = json["_code"] as? Int
        else {
            throw ContentError(.notContent)
        }
        
        guard code == 200 else {
            throw ContentError(.notContent)
        }
        
        guard let courseJSON = data["current_course"] as? [String: Any] else {
            return nil
        }
        
        guard
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
