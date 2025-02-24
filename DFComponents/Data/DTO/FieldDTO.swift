//
//  FieldDTO.swift
//  DFComponents
//
//  Created by ahmed maher on 23/02/2025.
//

import Foundation
struct TextBoxControlDTO: Decodable,Hashable{
    let id: String
    let type: FieldType
    var properties: TextBoxPropertiesDTO
//    let rules: TextBoxRulesDTO
}

struct TextBoxPropertiesDTO: Decodable,Hashable {
    let label: String
    var placeholder: String
    // You can add more TextBox-specific properties here.
}

struct TextBoxRulesDTO: Decodable,Hashable {
    let effectIn: [String]
    let dependOn: [String]
}


struct RadioControlDTO: Decodable,Hashable{
    let id: String
    let type: FieldType
    var properties: RadioButtonPropertiesDTO
   // let rules: RadioButtonRulesDTO
}

struct RadioButtonPropertiesDTO: Decodable,Hashable {
    let label: String
    var options:[Option]
    // Add any other RadioButton-specific properties here.
}

struct RadioButtonRulesDTO: Decodable,Hashable {
    let effectIn: [String]
    let dependOn: [String]
}
