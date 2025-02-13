//
//  APIClient.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

final class APIClient {
    static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            switch httpResponse.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            case 401:
                throw APIError.unauthorized
            default:
                throw APIError.unknown
            }
        } catch {
            throw APIError.network(error)
        }
    }
}

