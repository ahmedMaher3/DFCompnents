//
//  NetworkError.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public enum NetworkError: Error {
    case connectionFailed
    case unauthorized
    case serverError(Int)
    case decodingError
    case unknown
    case needsRetry
    case badRequest(String)
    case notFound
    case validationError([String: String])
    case rateLimitExceeded
    
    var userMessage: String {
        switch self {
        case .connectionFailed: return "No internet connection"
        case .unauthorized: return "Authentication required"
        case .serverError(let code): return "Server error: \(code)"
        case .decodingError: return "Data parsing failed"
        case .unknown: return "An unexpected error occurred"
        case .needsRetry: return "Operation needs retry"
        case .badRequest(let message): return "Bad request: \(message)"
        case .notFound: return "Resource not found"
        case .validationError(let errors): return "Validation errors: \(errors)"
        case .rateLimitExceeded: return "Too many requests. Please try again later"
        }
    }
}
