//
//  TextBoxInputFieldType.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.
//

import Foundation

struct TextBoxConfiguration {
    let title: String
    let subtitle: String?
    let placeholder: String
    let inputType: TextBoxInputFieldType
    let minLength: Int
    let prefix: String?  // Prefix text or dropdown
    let suffix: String?  // Suffix text
}

enum TextBoxInputFieldType {
    case numbersOnly
    case mixed
}
