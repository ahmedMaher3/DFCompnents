//
//  GlobalErrorHandler.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public actor GlobalErrorHandler {
    public static let shared = GlobalErrorHandler()
    private var errorHandler: ((NetworkError) -> Void)?
    
    private init() {}
    
    public func setHandler(_ handler: @escaping (NetworkError) -> Void) {
        self.errorHandler = handler
    }
    
    func notify(error: NetworkError) {
        errorHandler?(error)
    }
}

