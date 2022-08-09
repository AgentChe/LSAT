//
//  EmailRegex.swift
//  Nursing
//
//  Created by Андрей Чернышев on 28.05.2022.
//

struct EmailRegex {
    func isValid(email: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        let result = email.range(
            of: emailPattern,
            options: .regularExpression
        )

        return result != nil
    }
}
