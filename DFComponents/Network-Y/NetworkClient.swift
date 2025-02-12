//
//  NetworkClient.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public actor NetworkClient {
    private let baseURL: URL
    private var dynamicHeaders: [String: String] = [:]
    private let interceptorChain: InterceptorChain
    private let session: URLSession
    
    public init(
        baseURL: URL,
        initialHeaders: [String: String] = [:],
        interceptorChain: InterceptorChain = InterceptorChain(),
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.dynamicHeaders = initialHeaders
        self.interceptorChain = interceptorChain
        self.session = session
        
        Task {
            await interceptorChain.addRequestModifier(DynamicHeaderModifier { [weak self] in
                guard let self = self else { return [:] }
                return await self.getCurrentHeaders()
            })
        }
    }
    
    private func getCurrentHeaders() -> [String: String] {
        return dynamicHeaders
    }
    
    public func setHeader(key: String, value: String?) {
        if let value = value {
            dynamicHeaders[key] = value
        } else {
            dynamicHeaders.removeValue(forKey: key)
        }
    }
    
    public func setHeaders(_ headers: [String: String?]) {
        headers.forEach { key, value in
            setHeader(key: key, value: value)
        }
    }
    
    public func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        contentType: ContentType = .json,
        parameters: [String: Any]? = nil,
        timeout: TimeInterval = 30
    ) async throws -> T {
        
        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            throw NetworkError.unknown
        }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method
        request.setValue(contentType.headerValue, forHTTPHeaderField: "Content-Type")
        
        switch contentType {
        case .json:
            if let parameters = parameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }
        case .formUrlEncoded:
            if let parameters = parameters {
                let bodyString = parameters.map { "\($0.key)=\(String(describing: $0.value))" }
                    .joined(separator: "&")
                request.httpBody = bodyString.data(using: .utf8)
            }
        case .multipartFormData(let boundary):
            request.httpBody = createMultipartBody(parameters: parameters ?? [:], boundary: boundary)
        case .custom:
            break
        }
        
        let processedRequest = await interceptorChain.processRequest(request)
        
        let (data, response) = try await session.data(for: processedRequest)
        
        let (processedData, processedError) = await interceptorChain.processResponse(
            response: response as? HTTPURLResponse,
            data: data,
            error: nil
        )
        
        guard let processedData else {
            throw processedError ?? NetworkError.unknown
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: processedData)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func createMultipartBody(parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
