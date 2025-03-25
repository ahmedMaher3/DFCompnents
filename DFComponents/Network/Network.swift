//
//  Network.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//

import Foundation

protocol NetworkProtocol {
    func request<T: Codable>(_ endpoint: BaseEndpoint) async throws -> T
}

final class DefaultNetworkClient: NetworkProtocol {
    private let transport: NetworkTransport
    private let interceptor: RequestModifierInterceptor
    private let responseProcessor: ResponseProcessorProtocol

    init(
        transport: NetworkTransport = NetworkService(),
        requestModifiers: [RequestModifier] = [],
        responseProcessor: ResponseProcessorProtocol = DefaultResponseProcessor(errorHandler: DefaultErrorHandler())
    ) {
        self.transport = transport
        self.interceptor = RequestModifierInterceptor(modifiers: requestModifiers)
        self.responseProcessor = responseProcessor
    }

    func request<T: Decodable>(_ endpoint: BaseEndpoint) async throws -> T {
        var request = endpoint.urlRequest
        request = await interceptor.modify(request: request)

        let (data, response) = try await transport.sendRequest(request)

        return try await responseProcessor.process(response: response, data: data, type: T.self)
    }
}
