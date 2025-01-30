//
//  TextBoxConfiguration.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.
//

import Foundation


// MARK: - TextBoxConfiguration
struct TextBoxConfiguration: Hashable {
    var title: String
    var subtitle: String?
    var placeholder: String
    var inputType: InputType
    var minLength: Int
    var prefixOptions: [String] = []
    var suffixOptions: [String] = []
    var requiresPrefix: Bool = false
    var requiresSuffix: Bool = false
}

enum InputType {
    case numbersOnly
    case mixed
}
