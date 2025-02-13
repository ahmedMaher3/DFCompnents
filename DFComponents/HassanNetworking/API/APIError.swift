//
//  APIError.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case network(Error)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingFailed: return "Failed to decode response"
        case .network(let error): return error.localizedDescription
        case .unauthorized: return "Unauthorized request"
        case .unknown: return "An unknown error occurred"
        }
    }
}
