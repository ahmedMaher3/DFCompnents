//
//  ContentType.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/12/25.
//

import Foundation

public enum ContentType {
    case json
    case formUrlEncoded
    case multipartFormData(boundary: String)
    case custom(String)
    
    var headerValue: String {
        switch self {
        case .json: return "application/json"
        case .formUrlEncoded: return "application/x-www-form-urlencoded"
        case .multipartFormData(let boundary): return "multipart/form-data; boundary=\(boundary)"
        case .custom(let value): return value
        }
    }
}
