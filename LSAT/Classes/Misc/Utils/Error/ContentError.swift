//
//  ContentError.swift
//  Nursing
//
//  Created by Андрей Чернышев on 31.03.2022.
//

public struct ContentError: Error {
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

