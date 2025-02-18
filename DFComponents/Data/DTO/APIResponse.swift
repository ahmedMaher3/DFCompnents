//
//  APIResponse.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

struct APIResponse: Codable {
    let hasErrors: Bool
    let errors: String?
    let data: FormData
}

struct FormData: Codable {
    let schema: Schema
}

struct Schema: Codable {
    let id: String
    let lastAppliedEventId: String
    let properties: SchemaProperties
    let warnings: Warnings
    let fields: [Field]
    let rules: [Rule]
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
    let properties: FieldProperties
    let rules: FieldRules?
}

enum FieldType: String, Codable {
    case Page = "Page"
    case TextBox = "TextBox"
    case Number = "number"
    case DateTime = "datetime"
    case DropDown = "dropdown"
    case Radio = "Radio"
    case Checkbox = "checkbox"
    case FileUpload = "fileupload"
    case Location = "location"
}

struct FieldProperties: Codable {
    let submit, next, back: String?
    let backVisibility: Bool?
    let label: String
    let labelPosition, sublabel, tooltip: String?
    let localization: [String: String]?
    let options: [Option]?
    let predefinedOptionsId: String?
    let shuffleOptions, otherOption, naOption, required: Bool?
    let unique, addAttachment, addNote: Bool?
    let defaultAnswer: DefaultAnswer?
    let placeholder, attachmentType, attachmentExtensions: String?
    let maxAttachmentsNumber: Int?
    let hidden, disabled: Bool?
}

struct Option: Codable {
    let id, name: String
}

struct Rule: Codable {
    let id: String
    let disabled: Bool
    let operation: String
    let ifConditions: [IfCondition]
    let doActions: [DoAction]
    let actionsCategory: String
    let isValid: Bool
}

struct IfCondition: Codable {
    let fieldId, fieldState, target, value: String
    let quota: Int
}

struct DoAction: Codable {
    let type: String
    let sourceFieldsIds: [String]?
    let targetFieldsIds: [String]
    let expression: String?
    let actionImpact: String
}
