//
//  TextBoxControlDTO.swift
//  DFComponents
//
//  Created by hassan elshaer on 19/02/2025.
//
import Foundation

// MARK: - TextBoxControlDTO
struct TextBoxControlDTO: Control {
    var controlProperties: BaseProperties
    let id: String
    let type: String
    let parentId: String
    let rowIndex: Int?
    let order: String
    var properties: TextBoxProperties
    let rules: Rules
    let templateQuestionId: String?
    let visibilityPermissions: String?
    
    // MARK: - TextBoxProperties
    struct TextBoxProperties: Codable {
        var textBaseProperties: TextBaseProperties
        var interactiveProperties: InteractiveProperties

        // Default initializer
        init(
            textBaseProperties: TextBaseProperties = TextBaseProperties(),
            interactiveProperties: InteractiveProperties = InteractiveProperties()
        ) {
            self.textBaseProperties = textBaseProperties
            self.interactiveProperties = interactiveProperties
        }
    }
}

// MARK: - TextBaseProperties
struct TextBaseProperties: Codable {
    var allowSpellCheck: Bool
    var autoComplete: Bool
    var entryLimit: EntryLimit
    var maximumLength: Int
    var minimumLength: Int
    var textCase: TextCase

    // Default initializer
    init(
        allowSpellCheck: Bool = false,
        autoComplete: Bool = false,
        entryLimit: EntryLimit = .none,
        maximumLength: Int = 0,
        minimumLength: Int = 0,
        textCase: TextCase = .none
    ) {
        self.allowSpellCheck = allowSpellCheck
        self.autoComplete = autoComplete
        self.entryLimit = entryLimit
        self.maximumLength = maximumLength
        self.minimumLength = minimumLength
        self.textCase = textCase
    }
}

// MARK: - InteractiveProperties
struct InteractiveProperties: Codable {
    var required: Bool
    var disabled: Bool
    var hidden: Bool
    var defaultAnswer: DefaultAnswer?

    // MARK: - DefaultAnswer
    struct DefaultAnswer: Codable {
        var value: String?
        var prefix: String?
        var suffix: String?

        // Default initializer
        init(
            value: String? = nil,
            prefix: String? = nil,
            suffix: String? = nil
        ) {
            self.value = value
            self.prefix = prefix
            self.suffix = suffix
        }
    }

    // Default initializer
    init(
        required: Bool = false,
        disabled: Bool = false,
        hidden: Bool = false,
        defaultAnswer: DefaultAnswer? = nil
    ) {
        self.required = required
        self.disabled = disabled
        self.hidden = hidden
        self.defaultAnswer = defaultAnswer
    }
}

// MARK: - EntryLimit Enum
enum EntryLimit: String, Codable {
    case none
    case characterLimit
    case wordLimit
}

// MARK: - TextCase Enum
enum TextCase: String, Codable {
    case none
    case uppercase
    case lowercase
    case capitalize
}
