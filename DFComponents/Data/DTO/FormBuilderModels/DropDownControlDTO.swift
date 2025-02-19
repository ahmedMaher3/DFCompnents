//
//  DropDownControlDTO.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//

import Foundation

// MARK: - DropdownControl
struct DropdownControlDTO: Control {
    var controlProperties: ControlProperties
    struct DefaultAnswer: Codable {
         let value: [String]?
        let otherAnswer: String?
    }

    let id: String
    let type: String
    let parentId: String
    let rowIndex: Int?
    let order: String
    let properties: Properties
    let rules: Rules
    let templateQuestionId: String?
    let visibilityPermissions: String?
}

struct Properties: Codable {
    let controlProperties: ControlProperties // Composition
    let subType: String
    let multiSelect: Bool
    let selectAllBox: Bool
    let minNumberOfSelectedOptions: Int
    let maxNumberOfSelectedOptions: Int
    let options: [String]?
    let isCascade: Bool
    let predefinedOptionsId: String?
    let shuffleOptions: Bool
    let otherOption: Bool
    let otherOptionText: String?
    let naOption: Bool
    let naOptionText: String?
    let defaultAnswer: DefaultAnswer
}

