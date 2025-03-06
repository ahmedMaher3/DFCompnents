//
//  APIResponse.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

struct APIResponse: Decodable {
    let hasErrors: Bool
    let errors: String?
    let data: FormData
}

struct FormData: Decodable {
    let schema: Schema
}

struct Schema: Decodable {
    let id: String
    let lastAppliedEventId: String
    let properties: SchemaProperties
    let warnings: Warnings
    let fields: [Field]
    let rules: [Rule]
    let settings: Settings
}

struct Settings: Decodable {
    let format: FormType
}

enum FormType: String, Codable {
    case card = "Card"
    case classic = "Classic"
}

struct SchemaProperties: Codable {
    let localization: [String: String]?
    let submit, next, back, start, viewResults: String
    let backVisibility: Bool
}

struct Warnings: Codable {
    let formWarning: FormWarning
    let localization: [String: String]?
}

struct FormWarning: Codable {
    let formValidation: FormValidation
    let fieldValidation: FieldValidation
}

struct FormValidation: Codable {
    let expired, notAvailable, multipleSubmission, notStarted: String
}

struct FieldValidation: Codable {
    let emptyForm, required, maxAttachment: String
    let input: InputValidation
    let number: NumberValidation
    let dateTime: DateTimeValidation
    let mcq: MCQValidation
    let fileUpload: FileUploadValidation
    let location: LocationValidation
}

struct InputValidation: Codable {
    let minimumCharacterLength, maximumCharacterLength, minimumWordLength, maximumWordLength: String
    let email, url, numeric, alphabetic, alphanumeric, custom: String
}

struct NumberValidation: Codable {
    let minimumValue, maximumValue, minimumDigits, maximumDigits: String
}

struct DateTimeValidation: Codable {
    let dateTime, dateRange: String
}

struct MCQValidation: Codable {
    let minimumNumberOfSelectedOptions, maximumNumberOfSelectedOptions: String
}

struct FileUploadValidation: Codable {
    let maxFilesSize, maxSizePerFile, minNumberOfFiles, maxNumberOfFiles, allowedExtensions, invalidLink: String
}

struct LocationValidation: Codable {
    let maximumLocations, minimumLocations, notInRange: String
}

struct Field: Codable {
    let id, templateQuestionId, parentId: String?
    let type: FieldType
    let order: String
    var properties: BasePropertiesProtocol
    let rules: FieldRules?
    
    enum CodingKeys: String, CodingKey {
        case id, templateQuestionId, parentId, type, order, rules, properties
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.templateQuestionId = try container.decodeIfPresent(String.self, forKey: .templateQuestionId)
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        self.type = try container.decode(FieldType.self, forKey: .type)
        self.order = try container.decode(String.self, forKey: .order)
        self.rules = try container.decodeIfPresent(FieldRules.self, forKey: .rules)
        
        switch self.type {
            
        case .textBox:
            properties = try container.decode(TextBoxProperties.self, forKey: .properties)
        case .radio:
            properties = try container.decode(RadioProperties.self, forKey: .properties)
        default:
            properties = try container.decode(BaseProperties.self, forKey: .properties)
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(templateQuestionId, forKey: .templateQuestionId)
        try container.encode(parentId, forKey: .parentId)
        try container.encode(type, forKey: .type)
        try container.encode(order, forKey: .order)
        try container.encodeIfPresent(rules, forKey: .rules)
        try container.encode(properties, forKey: .properties)
    }
}

enum FieldType: String, Codable {
    case page = "Page"
    case textArea = "TextArea"
    case textBox = "TextBox"
    case number = "Number"
    case dateTime = "datetime"
    case dropDown = "dropdown"
    case radio = "Radio"
    case checkbox = "checkbox"
    case fileUpload = "fileupload"
    case location = "location"
    case section = "Section"
}

struct Option: Decodable, Identifiable {
    let id, name: String
    var isSelected: Bool? = false
}

struct Rule: Codable {
    let id: String
    let disabled: Bool
    let operation: RuleOperation
    let ifConditions: [IfCondition]
    let doActions: [DoAction]
    let actionsCategory: String
    let isValid: Bool
}

struct IfCondition: Codable {
    let fieldId, target, value: String
    let fieldState: FieldState
    let quota: Int
}

struct DoAction: Codable {
    let type: ActionType
    let sourceFieldsIds: [String]?
    let targetFieldsIds: [String]
    let expression: String?
    let actionImpact: String
}

enum RuleOperation: String, Codable {
    case any = "Any"
    case all = "All"
}

enum FieldState: String, Codable {
    case filled = "Filled"
    case empty = "Empty"
    case equal = "Equal"
    case notEqual = "NotEqual"
    case contains = "Contains"
    case notContain = "NotContain"
    case startsWith = "StartsWith"
    case notStartWith = "NotStartWith"
    case endsWith = "EndsWith"
    case notEndWith = "NotEndWith"
    case lessThan = "LessThan"
    case greaterThan = "GreaterThan"
    case after = "After"
    case before = "Before"
    case equalToDate = "EqualToDate"
    case notEqualToDate = "NotEqualToDate"
    case equalToTime = "EqualToTime"
    case notEqualToTime = "NotEqualToTime"
    case equalToDay = "EqualToDay"
    case notEqualToDay = "NotEqualToDay"
    case include = "Include"
    case notInclude = "NotInclude"
}

enum ActionType: String, Codable {
    case show = "Show"
    case enable = "Enable"
    case hide = "Hide"
    case disable = "Disable"
    case require = "Require"
    case unRequire = "UnRequire"
    case calculate = "Calculate"
    case copy = "Copy"
    case skipToPage = "SkipToPage"
}
