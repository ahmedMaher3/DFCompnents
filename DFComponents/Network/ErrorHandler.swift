//
//  ErrorHandler.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//
import Foundation


public protocol ErrorHandler {
    func evaluate(response: HTTPURLResponse?, data: Data?) async throws
}

public struct DefaultErrorHandler: ErrorHandler {
    public init() {}

    public func evaluate(response: HTTPURLResponse?, data: Data?) async throws {
        guard let response = response else {
            throw NetworkError.unknown
        }

        switch response.statusCode {
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError(response.statusCode)
        default:
            return 
        }
    }
}
