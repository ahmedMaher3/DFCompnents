//
//  ErrorHandler.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//
import Foundation


public protocol ErrorHandlerProtocol {
    func evaluate(response: HTTPURLResponse?) async throws
    func handleDecodingError(error: DecodingError) async throws  -> Never

}

public struct ErrorHandler: ErrorHandlerProtocol {


    public func evaluate(response: HTTPURLResponse?) async throws {
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
    
    public func handleDecodingError(error: DecodingError) async throws -> Never{
        switch error
        {
        case .typeMismatch(let type, let context):
            throw NetworkError.decodingError(.typeMismatch(
                expected: "\(type)",
                found: "Unexpected type",
                path: context.codingPath.map(\.stringValue).joined(separator: ".")
            ))
        case .valueNotFound(let type, let context):
            throw NetworkError.decodingError(.valueNotFound(
                type: "\(type)",
                path: context.codingPath.map(\.stringValue).joined(separator: ".")
            ))
        case .keyNotFound(let key, let context):
            throw NetworkError.decodingError(.keyNotFound(
                key: key.stringValue,
                path: context.codingPath.map(\.stringValue).joined(separator: ".")
            ))
        case .dataCorrupted(let context):
            throw NetworkError.decodingError(.dataCorrupted(reason: context.debugDescription))
        @unknown default:
            throw NetworkError.decodingError(.unknown(reason: error.localizedDescription))
        }
    }

}
