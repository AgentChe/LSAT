//
//  GetTestModeResponseMapper.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

final class GetTestModeResponseMapper {
    static func map(from response: Any) throws -> TestMode? {
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
        
        guard let testModeCode = data["test_mode"] as? Int else {
            return nil
        }
        
        return map(testModeCode: testModeCode)
    }
    
    static func map(testModeCode: Int) -> TestMode? {
        switch testModeCode {
        case 0:
            return .fullComplect
        case 1:
            return .noExplanations
        case 2:
            return .onAnExam
        default:
            return nil
        }
    }
}
