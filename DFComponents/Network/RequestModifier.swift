//
//  RequestModifier.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public protocol RequestModifier {
    func modify(request: URLRequest) async -> URLRequest
}

// MARK: - Request Modifiers
public struct DynamicHeaderModifier: RequestModifier {
    private let headerProvider: () async -> [String: String]
    
    public init(headerProvider: @escaping () async -> [String: String]) {
        self.headerProvider = headerProvider
    }
    
    public func modify(request: URLRequest) async -> URLRequest {
        var mutableRequest = request
        let headers = await headerProvider()
        headers.forEach { key, value in
            mutableRequest.setValue(value, forHTTPHeaderField: key)
        }
        return mutableRequest
    }
}

public struct AuthenticationModifier: RequestModifier {
    private let tokenProvider: () -> String?
    
    public init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }
    
    public func modify(request: URLRequest) async -> URLRequest {
        guard let token = tokenProvider() else { return request }
        var mutableRequest = request
        mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
}
