//
//  FieldProperties.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/19/25.
//

import Foundation

protocol BasePropertiesProtocol: Codable {
    var label: String? { get }
    var subLabel: String? { get }
    var labelPosition: String? { get }
    var tooltip: String? { get }
    var hidden: Bool? { get }
}

struct BaseProperties: BasePropertiesProtocol {
    var label: String?
    var subLabel: String?
    var labelPosition: String?
    var tooltip: String?
    var hidden: Bool?
    
    enum CodingKeys: String, CodingKey {
        case label, tooltip, hidden
        case subLabel = "sublabel"
        case labelPosition
    }
}

protocol InteractivePropertiesProtocol: BasePropertiesProtocol {
    var required: Bool? { get }
    var placeholder: String? { get }
    var addAttachment: Bool? { get }
    var addNote: Bool? { get }
    var attachmentExtensions: String? { get }
    var attachmentType: AttachmentType? { get }
    var disabled: Bool? { get }
}

protocol TextBaseProperties: InteractivePropertiesProtocol {
    var allowSpellcheck: Bool? { get }
    var autocomplete: Bool? { get }
    var entryLimit: EntryLimit? { get }
    var maximumLength: Int? { get }
    var minimumLength: Int? { get }
    var textCase: String? { get }
}

protocol MCQPropertiesProtocol: InteractivePropertiesProtocol {
    var options: [MCQOption]? { get }
    var defaultAnswer: BaseAnswerMCQ? { get }
    var predefinedOptions: String? { get }
    var shuffleOptions: Bool? { get }
    var otherOption: Bool? { get }
    var otherOptionText: String? { get }
    var naOption: Bool? { get }
    var naOptionText: String? { get }
}

struct TextBoxProperties: TextBaseProperties {
    let allowSpellcheck: Bool?
    let autocomplete: Bool?
    let entryLimit: EntryLimit?
    let maximumLength: Int?
    let minimumLength: Int?
    let textCase: String?
    let required: Bool?
    let placeholder: String?
    let addAttachment: Bool?
    let addNote: Bool?
    let attachmentExtensions: String?
    let attachmentType: AttachmentType?
    let disabled: Bool?
    let label: String?
    let subLabel: String?
    let labelPosition: String?
    let tooltip: String?
    let hidden: Bool?
    
    let defaultAnswer: TextboxAnswer?
    let mask: String?
//    let prefix:
//    let suffix:
    let regex: String?
    let subType: TextBoxSubType?
}

struct RadioProperties: MCQPropertiesProtocol {
    let options: [MCQOption]?
    let defaultAnswer: BaseAnswerMCQ?
    let predefinedOptions: String?
    let shuffleOptions: Bool?
    let otherOption: Bool?
    let otherOptionText: String?
    let naOption: Bool?
    let naOptionText: String?
    let required: Bool?
    let placeholder: String?
    let addAttachment: Bool?
    let addNote: Bool?
    let attachmentExtensions: String?
    let attachmentType: AttachmentType?
    let disabled: Bool?
    let label: String?
    let subLabel: String?
    let labelPosition: String?
    let tooltip: String?
    let hidden: Bool?
}

struct MCQOption: Codable {
    let id: String?
    let name: String?
    
    init(other: Bool, name: String?) {
        if other {
            id = "00000000-0000-0000-0000-000000000000"
        } else {
            id = "00000000-0000-0000-0000-000000000001"
        }
        self.name = name
    }
}

enum EntryLimit: String, Codable {
    case character = "Character"
    case word = "Word"
    case digit = "Digit"
}

enum TextBoxSubType: String, Codable {
    case any = "Any"
    case email = "Email"
    case url = "URL"
    case numeric = "Numeric"
    case alphabetic = "Alphabetic"
    case alphanumeric = "Alphanumeric"
    case custom = "Custom"
}

enum AttachmentType: String, Codable {
    case image = "Image"
    case file = "File"
    case both = "Both"
}
