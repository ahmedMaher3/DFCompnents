//
//  FormMainDTO.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//

import Foundation

// MARK: - Common Protocol
protocol Control: Codable {
    var id: String { get }
    var type: String { get }
    var parentId: String { get }
    var rowIndex: Int? { get }
    var order: String { get }
    var templateQuestionId: String? { get }
    var visibilityPermissions: String? { get }
    var rules: Rules { get }
    associatedtype PropertiesType: Codable
    var properties: PropertiesType { get }
    var controlProperties: BaseProperties { get } // Composition
}

// MARK: - Common Models
struct Rules: Codable {
    let effectIn: [String]?
    let dependOn: [String]?
}

struct Localization: Codable {
    struct FieldWarning: Codable {
        let required: String?
    }

    struct Language: Codable {
        let placeholder: String?
        let label: String?
        let sublabel: String?
        let tooltip: String?
        let fieldWarning: FieldWarning?
    }

    let en: Language
    let ar: Language
}

struct Style: Codable {
    let border: String?
    let borderType: String?
    let borderColor: String?
    let backgroundColor: String?
    let textColor: String?
    let textAlign: String?
    let font: String?
    let fontSize: String?
}

typealias BaseLocalization = [String: BasePropertiesLocalization]

struct BasePropertiesLocalization: Codable, Identifiable {
    var id = UUID() // Add an `id` property to conform to SwiftUI lists
    var label: String?
    var sublabel: String?
    var tooltip: String?
    var fieldWarning: InternalFieldValidation?
    var ruleWarning: InternalRuleValidation?

    // Default initializer
    init(
        label: String? = nil,
        sublabel: String? = nil,
        tooltip: String? = nil,
        fieldWarning: InternalFieldValidation? = nil,
        ruleWarning: InternalRuleValidation? = nil
    ) {
        self.label = label
        self.sublabel = sublabel
        self.tooltip = tooltip
        self.fieldWarning = fieldWarning
        self.ruleWarning = ruleWarning
    }
}

struct InternalRuleValidation: Codable, Equatable {
    var unique: String?
    
    // Optional: Add a default initializer if needed
    init(unique: String? = nil) {
        self.unique = unique
    }
}


struct InternalFieldValidation: Codable, Equatable {
    var required: String?
    var minimumNumberOfSelectedOptions: String?
    var maximumNumberOfSelectedOptions: String?
    var minimumCharacterLength: String?
    var maximumCharacterLength: String?
    var minimumWordLength: String?
    var maximumWordLength: String?
    var email: String?
    var url: String?
    var numeric: String?
    var alphabetic: String?
    var alphanumeric: String?
    var custom: String?
    var minimumValue: String?
    var maximumValue: String?
    var minimumDigits: String?
    var maximumDigits: String?
    var dateTime: String?
    var maxAttachment: String?
    var minimumDate: String?
    var maximumDate: String?
    var minimumTime: String?
    var maximumTime: String?
    var allowedDaysRange: String?
    var minRows: String?
    var maxRows: String?
    var maxAttachmentSize: String?
    var attachmentType: String?
    var attachmentExtensions: String?
    
    // Optional: Add a default initializer if needed
    init(
        required: String? = nil,
        minimumNumberOfSelectedOptions: String? = nil,
        maximumNumberOfSelectedOptions: String? = nil,
        minimumCharacterLength: String? = nil,
        maximumCharacterLength: String? = nil,
        minimumWordLength: String? = nil,
        maximumWordLength: String? = nil,
        email: String? = nil,
        url: String? = nil,
        numeric: String? = nil,
        alphabetic: String? = nil,
        alphanumeric: String? = nil,
        custom: String? = nil,
        minimumValue: String? = nil,
        maximumValue: String? = nil,
        minimumDigits: String? = nil,
        maximumDigits: String? = nil,
        dateTime: String? = nil,
        maxAttachment: String? = nil,
        minimumDate: String? = nil,
        maximumDate: String? = nil,
        minimumTime: String? = nil,
        maximumTime: String? = nil,
        allowedDaysRange: String? = nil,
        minRows: String? = nil,
        maxRows: String? = nil,
        maxAttachmentSize: String? = nil,
        attachmentType: String? = nil,
        attachmentExtensions: String? = nil
    ) {
        self.required = required
        self.minimumNumberOfSelectedOptions = minimumNumberOfSelectedOptions
        self.maximumNumberOfSelectedOptions = maximumNumberOfSelectedOptions
        self.minimumCharacterLength = minimumCharacterLength
        self.maximumCharacterLength = maximumCharacterLength
        self.minimumWordLength = minimumWordLength
        self.maximumWordLength = maximumWordLength
        self.email = email
        self.url = url
        self.numeric = numeric
        self.alphabetic = alphabetic
        self.alphanumeric = alphanumeric
        self.custom = custom
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.minimumDigits = minimumDigits
        self.maximumDigits = maximumDigits
        self.dateTime = dateTime
        self.maxAttachment = maxAttachment
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.minimumTime = minimumTime
        self.maximumTime = maximumTime
        self.allowedDaysRange = allowedDaysRange
        self.minRows = minRows
        self.maxRows = maxRows
        self.maxAttachmentSize = maxAttachmentSize
        self.attachmentType = attachmentType
        self.attachmentExtensions = attachmentExtensions
    }
}


enum TextBoxSubType: String, Codable, CaseIterable, Identifiable {
    case anySubType = "Any"
    case email = "Email"
    case url = "URL"
    case numeric = "Numeric"
    case alphabetic = "Alphabetic"
    case alphanumeric = "Alphanumeric"
    case custom = "Custom"
    case password = "password"

    // Add `id` to conform to `Identifiable` for SwiftUI lists
    var id: String { self.rawValue }

    // Optional: Provide user-friendly names if needed
    var displayName: String {
        switch self {
        case .anySubType: return "Any"
        case .email: return "Email"
        case .url: return "URL"
        case .numeric: return "Numeric"
        case .alphabetic: return "Alphabetic"
        case .alphanumeric: return "Alphanumeric"
        case .custom: return "Custom"
        case .password: return "Password"
        }
    }
}


struct DataSource: Codable, Equatable {
    var excludedViews: [ExcludedViews]?
    var parameters: [String]?
    
    // Custom initializer for convenience
    init(excludedViews: [ExcludedViews]? = nil, parameters: [String]? = nil) {
        self.excludedViews = excludedViews
        self.parameters = parameters
    }
}

enum ExcludedViews: String, Codable, CaseIterable, Identifiable {
    case create = "Create"
    case taskDetails = "TaskDetails"
    case requestDetails = "RequestDetails"
    case edit = "Edit"

    // Adding `id` for Identifiable conformance in SwiftUI
    var id: String { self.rawValue }

    // Optional: Provide a user-friendly display name
    var displayName: String {
        switch self {
        case .create: return "Create View"
        case .taskDetails: return "Task Details View"
        case .requestDetails: return "Request Details View"
        case .edit: return "Edit View"
        }
    }
}


struct BaseProperties: Codable {
    var label: String?
    var subLabel: String?
    var labelPosition: String?
    var tooltip: String?
    var hidden: Bool?
    var disabled: Bool?
    var localization: BaseLocalization?
    var subType: TextBoxSubType?
    var isCollapsedSec: Bool?
    var dataSourcId: String?
    var dataSource: DataSource?
    var readonly: Bool?
    var required: Bool?
    var hideIfEmptyInDetails: Bool?

    // Default initializer
    init(
        label: String? = nil,
        subLabel: String? = nil,
        labelPosition: String? = nil,
        tooltip: String? = nil,
        hidden: Bool? = nil,
        disabled: Bool? = nil,
        localization: BaseLocalization? = nil,
        subType: TextBoxSubType? = nil,
        isCollapsedSec: Bool? = nil,
        dataSourcId: String? = nil,
        dataSource: DataSource? = nil,
        readonly: Bool? = nil,
        required: Bool? = nil,
        hideIfEmptyInDetails: Bool? = nil
    ) {
        self.label = label
        self.subLabel = subLabel
        self.labelPosition = labelPosition
        self.tooltip = tooltip
        self.hidden = hidden
        self.disabled = disabled
        self.localization = localization
        self.subType = subType
        self.isCollapsedSec = isCollapsedSec
        self.dataSourcId = dataSourcId
        self.dataSource = dataSource
        self.readonly = readonly
        self.required = required
        self.hideIfEmptyInDetails = hideIfEmptyInDetails
    }
    
    // Update a property dynamically using KeyPath
    mutating func updateProperty<Value>(keyPath: WritableKeyPath<BaseProperties, Value?>, newValue: Value?) {
        self[keyPath: keyPath] = newValue
    }
}

