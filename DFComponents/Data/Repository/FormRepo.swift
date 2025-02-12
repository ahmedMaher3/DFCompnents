//
//  FormRepo.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

protocol FormRepo {
    func fetchForms() async throws -> [FormDTO]
}

class FormRepoImpl: FormRepo {
    private let networkClient: NetworkClient
    
    init() {
        // Setup network client with base URL and interceptors
        let chain = InterceptorChain()
        
        // Add logging
        Task {
            await chain.addResponseHandler(LoggingResponseHandler())
            
            // Add authentication if needed
            await chain.addRequestModifier(AuthenticationModifier {
//                UserDefaults.standard.string(forKey: "accessToken")
                "accessTokenHere"
            })
            
            await chain.addRequestModifier(DynamicHeaderModifier(headerProvider: {
                ["lang": "1"]
            }))
            
            //add multiple interceptors here
        }
        
        self.networkClient = NetworkClient(
            baseURL: URL(string: "https://jsonplaceholder.typicode.com")!,
            interceptorChain: chain
        )
    }
    
    func fetchForms() async throws -> [FormDTO] {
        let response: [FormDTO] = try await networkClient.request(endpoint: "Forms", method: "GET")
        return response
    }
}
