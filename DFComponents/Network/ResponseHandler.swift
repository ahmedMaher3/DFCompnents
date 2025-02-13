//
//  ResponseHandler.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public protocol ResponseHandler {
    func handle(response: HTTPURLResponse?, data: Data?, error: Error?) async -> (Data?, Error?)
}

public struct LoggingResponseHandler: ResponseHandler {
    public init() {}
    
    public func handle(response: HTTPURLResponse?, data: Data?, error: Error?) async -> (Data?, Error?) {
        if let response = response {
            print("Network Response: \(response.statusCode)")
        }
        if let error = error {
            print("Network Error: \(error.localizedDescription)")
        }
        return (data, error)
    }
}

public struct ErrorInterceptor: ResponseHandler {
    public init() {}

    public func handle(response: HTTPURLResponse?, data: Data?, error: Error?) async -> (Data?, Error?) {
        if let error = error {
            await GlobalErrorHandler.shared.notify(error: NetworkError.unknown) // Generic error
            return (nil, error)
        }

        guard let response = response else {
            await GlobalErrorHandler.shared.notify(error: NetworkError.unknown)
            return (nil, NetworkError.unknown)
        }

        let networkError: NetworkError?
        
        switch response.statusCode {
        case 200..<300:
            return (data, nil) // Maybe add server error handling here
        case 401:
            networkError = .unauthorized
        case 404:
            networkError = .notFound
        case 500..<600:
            networkError = .serverError(response.statusCode)
        default:
            networkError = .unknown
        }

        if let errorToSend = networkError {
            await GlobalErrorHandler.shared.notify(error: errorToSend)
            return (nil, errorToSend)
        }

        return (data, nil)
    }
}
