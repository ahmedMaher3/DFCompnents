//
//  Network.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Codable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkClient: NetworkProtocol {
    private let network: NetworkServiceProtocol
    private let interceptor: InterceptorChainProtocol
    private let responseProcessor: ResponseProcessorProtocol

    init(
        network: NetworkServiceProtocol = NetworkService(),
        requestModifiers: [RequestModifier] = [],
        responseProcessor: ResponseProcessorProtocol = ResponseProcessor()
    ) {
        self.network = network
        self.interceptor = InterceptorChain(modifiers: requestModifiers)
        self.responseProcessor = responseProcessor
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = endpoint.urlRequest
        request = await interceptor.modify(request: request)

        let (data, response) = try await network.sendRequest(request)

        return try await responseProcessor.process(response: response, data: data)
    }
}
