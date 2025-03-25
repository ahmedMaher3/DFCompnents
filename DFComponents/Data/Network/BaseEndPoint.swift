//
//  BaseEndPoint.swift
//  DFComponents
//
//  Created by ahmed maher on 24/03/2025.
//
import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: URL { NetworkConfig.baseURL }
    var headers: [String: String] { [:] }
    var body: Data? { nil }

    var urlRequest: URLRequest {
           var request = URLRequest(url: baseURL.appendingPathComponent(path))
           request.httpMethod = method.rawValue
           headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
           request.httpBody = body
           return request
       }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

struct NetworkConfig {
    static var baseURL: URL {
        return URL(string: "https://restcountries.com/v2/")!

    }
}
