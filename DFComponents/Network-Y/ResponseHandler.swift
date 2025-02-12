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

