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

public struct ErrorPropagationHandler: ResponseHandler {
    public init() {}

    public func handle(response: HTTPURLResponse?, data: Data?, error: Error?) async -> (Data?, Error?) {
        if let error = error {
            return (nil, error)
        }
        
        guard let response = response else {
            return (nil, NetworkError.unknown)
        }
        
        switch response.statusCode {
        case 200..<300:
            return (data, nil)
        case 401:
            return (nil, NetworkError.unauthorized)
        case 404:
            return (nil, NetworkError.notFound)
        case 500..<600:
            return (nil, NetworkError.serverError(response.statusCode))
        default:
            return (nil, NetworkError.unknown)
        }
    }
}
