//
//  ResponseHandler.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public protocol ResponseProcessorProtocol {
    func process<T: Decodable>(response: URLResponse?, data: Data?) async throws -> T
}

final class ResponseProcessor: ResponseProcessorProtocol {
    private let errorHandler: ErrorHandler

    init(errorHandler: ErrorHandler = ErrorHandler()) {
        self.errorHandler = errorHandler
    }

    func process<T: Decodable>(response: URLResponse?, data: Data?) async throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }

        if !(200..<300).contains(httpResponse.statusCode) {
            try await errorHandler.evaluate(response: httpResponse)
        }

        guard let validData = data else {
            throw NetworkError.unknown
        }
        do {
            return try JSONDecoder().decode(T.self, from: validData)
        }
        catch let decodingError as DecodingError {
             try await errorHandler.handleDecodingError(error: decodingError) // ✅ Explicitly throwing
        }



    }

}
