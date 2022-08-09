//
//  GetTestConfigResponseMapper.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 15.02.2021.
//

final class GetTestConfigResponseMapper {
    static func from(response: Any) -> [TestConfig] {
        guard
            let string = response as? String,
            let json = XOREncryption.toJSON(string, key: GlobalDefinitions.apiKey),
            let data = json["_data"] as? [String: Any],
            let tests = data["tests"] as? [[String: Any]]
        else {
            return []
        }
        
        return tests
            .compactMap { testJSON -> TestConfig? in
                guard
                    let id = testJSON["id"] as? Int,
                    let paid = testJSON["paid"] as? Bool
                else {
                    return nil
                }
                
                return TestConfig(id: id, paid: paid)
            }
    }
}
