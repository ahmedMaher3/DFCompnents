//
//  Interceptor.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

// MARK: - Interceptor Chain
public actor InterceptorChain {
    private var requestModifiers: [RequestModifier] = []
    private var responseHandlers: [ResponseHandler] = []
    
    public init() {}
    
    public init(
        requestModifiers: [RequestModifier] = [],
        responseHandlers: [ResponseHandler] = []
    ) {
        self.requestModifiers = requestModifiers
        self.responseHandlers = responseHandlers
    }
    
    public func addRequestModifier(_ modifier: RequestModifier) {
        requestModifiers.append(modifier)
    }
    
    public func addResponseHandler(_ handler: ResponseHandler) {
        responseHandlers.append(handler)
    }
    
    func processRequest(_ request: URLRequest) async -> URLRequest {
        var processedRequest = request
        for modifier in requestModifiers {
            processedRequest = await modifier.modify(request: processedRequest)
        }
        return processedRequest
    }
    
    func processResponse(response: HTTPURLResponse?, data: Data?, error: Error?) async -> (Data?, Error?) {
        var result = (data, error)
        for handler in responseHandlers {
            result = await handler.handle(response: response, data: result.0, error: result.1)
        }
        return result
    }
}
