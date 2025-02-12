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
            
            await chain.addResponseHandler(ErrorInterceptor())
            // Add multiple interceptors here
        }
        
        self.networkClient = NetworkClient(
            baseURL: URL(string: "https://jsonplaceholder.typicode.com")!,
            interceptorChain: chain
        )
        
        Task {
            await GlobalErrorHandler.shared.setHandler { error in
                switch error {
                case .unauthorized:
                    print("User is unauthorized! Logging out...")
                case .notFound:
                    print("Resource not found.")
                case .connectionFailed:
                    print("No internet connection! Show alert.")
                case .serverError(let code):
                    print("Server error: \(code)")
                default:
                    print("Unhandled error: \(error)")
                }
            }
        }
    }
    
    func fetchForms() async throws -> [FormDTO] {
        let response: [FormDTO] = try await networkClient.request(endpoint: "Forms", method: "GET")
        return response
    }
    
    // using fetchForms throws an error of type Network Error.
}
