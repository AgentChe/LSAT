//
//  ContentError.swift
//  EMT
//
//  Created by Андрей Чернышев on 11.04.2022.
//

struct ContentError: Error {
    public enum Code {
        case notContent
    }

    public let code: Code
    public let underlyingError: Error?

    init(_ code: Code, underlyingError: Error? = nil) {
        self.code = code
        self.underlyingError = underlyingError
    }
}
