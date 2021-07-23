//
//  GetReferencesResponseMapper.swift
//  FNP
//
//  Created by Andrey Chernyshev on 10.07.2021.
//

final class GetReferencesResponseMapper {
    static func map(from response: Any) -> [Reference] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let referencesArray = data["references"] as? [[String: Any]]
        else {
            return []
        }
        
        return referencesArray.compactMap { json -> Reference? in
            guard
                let title = json["title"] as? String,
                let details = json["details"] as? String
            else {
                return nil
            }
            
            return Reference(title: title,
                             details: details,
                             link: json["link"] as? String)
        }
    }
}
