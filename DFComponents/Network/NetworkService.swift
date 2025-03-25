//
//  NetworkService.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//

import Foundation

protocol NetworkTransport {
    func sendRequest(_ request: URLRequest) async throws -> (Data, URLResponse)
}

final class NetworkService: NetworkTransport {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func sendRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
