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

struct AuthorizationModifier: RequestModifier {
    func modify(request: URLRequest) async -> URLRequest {
        var modifiedRequest = request
        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            modifiedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return modifiedRequest
    }
}

struct APIKeyModifier: RequestModifier {
    func modify(request: URLRequest) async -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.setValue("API_KEY_VALUE", forHTTPHeaderField: "x-api-key")
        return modifiedRequest
    }
}
