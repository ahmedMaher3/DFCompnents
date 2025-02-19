//
//  TextBoxControlDTO.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//
import Foundation

// MARK: - TextBoxControl
struct TextBoxControlDTO: Control {
    var controlProperties: ControlProperties
    let id: String
    let type: String
    let parentId: String
    let rowIndex: Int?
    let order: String
    let properties: TextBoxProperties
    let rules: Rules
    let templateQuestionId: String?
    let visibilityPermissions: String?
    struct TextBoxProperties: Codable {
        let mask: String
        let regex: String
        let subType: String
        let autoComplete: Bool
        let allowSpellCheck: Bool
        let textCase: String
        let entryLimit: String
        let minimumLength: Int
        let maximumLength: Int
        let defaultAnswer: DefaultAnswer
    }

    struct DefaultAnswer: Codable {
        let value: String?
        let prefix: String?
        let suffix: String?
    }
}
