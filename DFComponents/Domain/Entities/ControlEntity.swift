//
//  ControlEntity.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FieldPropertiesProtocol {
    var placeholder: String? { get } 

}


struct TextBoxProperties: FieldPropertiesProtocol {
    var placeholder: String?
    var maxLength: Int

}

struct DropDownProperties: FieldPropertiesProtocol {
    var placeholder: String?

}


enum ControlType {
    case textBox(ControlEntity<TextBoxProperties>)
    case dropDown(ControlEntity<DropDownProperties>)
    var id: String {
           switch self {
           case .textBox(let entity): return "\(entity.id)"
           case .dropDown(let entity): return "\(entity.id)"
           }
       }
}

protocol ControlEntityProtocol {
    var id: String { get }
}
struct ControlEntity<T: FieldPropertiesProtocol>: ControlEntityProtocol {
    let id: String
    let properties: T
}


//struct Field: Codable {
//    let id, templateQuestionId, parentId: String?
//    let type: FieldType
//    let order: String
//    let properties: FieldProperties
//    let rules: FieldRules?
//}
