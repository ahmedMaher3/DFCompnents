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
    let properties: BasePropertiesProtocol
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
        case .TextBox:
            properties = try container.decode(TextBoxProperties.self, forKey: .properties)
        case .Radio:
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
    var hidden, disabled: Bool?
}

struct Option: Decodable, Identifiable {
    let id, name: String
    var isSelected: Bool? = false
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

//enum FieldDTOEnum: Decodable {
//    case textBox(TextBoxControlDTO)
//    case radio(RadioControlDTO)
//
//    var id: String {
//        switch self {
//        case .textBox(let dto):
//            return dto.id
//        case .radio(let dto):
//            return dto.id
//        }
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let type = try container.decode(FieldType.self, forKey: .type)
//        switch type {
//        case .TextBox:
//            let dto = try TextBoxControlDTO(from: decoder)
//            self = .textBox(dto)
//        case.Radio:
//            let dto = try RadioControlDTO(from: decoder)
//            self = .radio(dto)
//        default:
//            let dto = try TextBoxControlDTO(from: decoder)
//            self = .textBox(dto)
//
//        }
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case type
//    }
//}


//protocol RuleExecuterProtocol {
//    func executeActions(valid: Bool, doActions: [DoAction], controls: inout [Field])
//}
//
//protocol RuleEvaluator {
//    func getRules(forControlId controlId: String, controls: [Field]) -> [String]
//    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction])
//    func validateCondition(_ condition: IfCondition) -> Bool
//}

//protocol DefaultVal {
//
//}
//
//struct RuleImp: RuleEvaluator, RuleExecuterProtocol {
//
//    var controls: [Field]
//
//    init(controls: [Field]) {
//        self.controls = controls
//    }
//
//    func getRules(forControlId controlId: String, controls: [Field]) -> [String] {
//        guard let control = controls.first(where: { $0.id == controlId }) else {
//            return []
//        }
//        return control.rules?.effectIn ?? [] // get affected rules ids
//    }
//
//    func evaluateRules(rules: [Rule]) -> (valid: Bool, doActions: [DoAction]) {
//        for rule in rules {
//            guard !rule.disabled else { continue } // Skip disabled rules
//
//            let areConditionsValid: Bool
//            switch rule.operation {
//            case "All":
//                areConditionsValid = rule.ifConditions.allSatisfy { validateCondition($0) }
//            case "Any":
//                areConditionsValid = rule.ifConditions.contains { validateCondition($0) }
//            default:
//                areConditionsValid = false
//            }
//
//            if areConditionsValid {
//                return (true, rule.doActions)
//            }
//        }
//        return (false, [])
//    }
//
//    func validateCondition(_ condition: IfCondition) -> Bool { // Ongoing function
//
//        var defVal: DefaultVal?
//        var conditionIsValid: Bool = false
//
//        if condition.target == "Value" { // target
//            let checkedFieldID = condition.fieldId // fieldId
//            if let control = controls.first(where: {
//                $0.id == checkedFieldID
//            }) {
//                // get value from control
//                defVal = control.properties.defaultAnswer as? DefaultVal
//            }
//        }
//
//    //    switch condition.fieldState {
//    //
//    //    case "Include", "NotInclude":
//    //        handleIncludeState(
//    //            value, valueValidator, valid: &conditionIsValid,
//    //            include: condition.fieldState == "Include")
//    //    default:
//    //        return false
//    //    }
//
//        return conditionIsValid
//    }
//
//    func getItemValue(control: Field) -> DefaultVal? {
//        switch control.type {
//        case .Radio:
//    //        return control.properties.defaultAnswer as! RadioAnswer
//            return nil
//        default:
//            return nil
//        }
//    }
//
//    func handleIncludeState(
//        _ value: [String]?, _ valueValidator: [String]?, valid: inout Bool,
//        include: Bool
//    ) {
//        guard let validatorValue = valueValidator, let itemValue = value else {
//            return
//        }
//        for value in validatorValue {
//            if include {
//                if itemValue.contains(where: {
//                    $0.lowercased() == value.lowercased()
//                }) {
//                    valid = true
//                }
//            } else {
//                if !itemValue.contains(where: { $0 == value }) {
//                    valid = true
//                }
//            }
//
//        }
//    }
//
//    func executeActions(valid: Bool, doActions: [DoAction], controls: inout [Field]) {
//        guard valid else { return }
//
//        for action in doActions {
//            for targetFieldId in action.targetFieldsIds {
//                guard let targetControlIndex = controls.firstIndex(where: { $0.id == targetFieldId }) else {
//                    continue
//                }
//
////                switch action.type {
////                case "Show":
////                    controls[targetControlIndex].properties.hidden = valid
////                case "Hide":
////                    controls[targetControlIndex].properties.hidden = !valid
////                default:
////                    break
////                }
//            }
//        }
//    }
//
//}
