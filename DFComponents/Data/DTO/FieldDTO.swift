//
//  FieldDTO.swift
//  DFComponents
//
//  Created by ahmed maher on 23/02/2025.
//

import Foundation
struct TextBoxxDTO: Decodable {
    let id: String
    let type: FieldType
    let properties: TextBoxPropertiesDTO
    let rules: TextBoxRulesDTO
}

struct TextBoxPropertiesDTO: Decodable {
    let mask: String
    let placeholder: String
    // You can add more TextBox-specific properties here.
}

struct TextBoxRulesDTO: Decodable {
    let effectIn: [String]
    let dependOn: [String]
}


struct RadioDTO: Decodable {
    let id: String
    let type: FieldType
    let properties: RadioButtonPropertiesDTO
    let rules: RadioButtonRulesDTO
}

struct RadioButtonPropertiesDTO: Decodable {
    let options: [String]
    let label: String
    // Add any other RadioButton-specific properties here.
}

struct RadioButtonRulesDTO: Decodable {
    let effectIn: [String]
    let dependOn: [String]
}
