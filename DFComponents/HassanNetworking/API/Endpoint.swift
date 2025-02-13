//
//  Endpoint.swift
//  DFComponents
//
//  Created by hassan elshaer on 13/02/2025.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var url: URL? { get }
}

enum UserAPI: Endpoint {
    case getUsers
    case getUser(id: Int)

    var path: String {
        switch self {
        case .getUsers: return "/users"
        case .getUser(let id): return "/users/\(id)"
        }
    }

    var method: String { "GET" }

    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }

    var url: URL? {
        URL(string: "https://jsonplaceholder.typicode.com" + path)
    }
}
