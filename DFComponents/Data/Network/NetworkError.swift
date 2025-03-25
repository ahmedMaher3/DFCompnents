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
    case decodingError(DecodingErrorDetail)
    case unknown
    case needsRetry
    case badRequest(String)
    case notFound
    case validationError([String: String])
    case rateLimitExceeded

    public enum DecodingErrorDetail {
        case typeMismatch(expected: String, found: String, path: String)
        case valueNotFound(type: String, path: String)
        case keyNotFound(key: String, path: String)
        case dataCorrupted(reason: String)
        case unknown(reason: String)
    }

    var localizedDescription: String {
        switch self {
        case .connectionFailed:
            return "No internet connection"
        case .unauthorized:
            return "Authentication required"
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError(let detail):
            return "Decoding error: \(detail.localizedDescription)"
        case .unknown:
            return "An unexpected error occurred"
        case .needsRetry:
            return "Operation needs retry"
        case .badRequest(let message):
            return "Bad request: \(message)"
        case .notFound:
            return "Resource not found"
        case .validationError(let errors):
            return "Validation errors: \(errors)"
        case .rateLimitExceeded:
            return "Too many requests. Please try again later"
        }
    }
}

extension NetworkError.DecodingErrorDetail {

    var localizedDescription: String {
        switch self {
        case .typeMismatch(let expected, let found, let path):
            return "Expected type '\(expected)', but found '\(found)' at '\(path)'."
        case .valueNotFound(let type, let path):
            return "Missing value for type '\(type)' at '\(path)'."
        case .keyNotFound(let key, let path):
            return "Missing key '\(key)' at '\(path)'."
        case .dataCorrupted(let reason):
            return "Data corrupted: \(reason)"
        case .unknown(let reason):
            return "Unknown decoding error: \(reason)"
        }
    }
}
