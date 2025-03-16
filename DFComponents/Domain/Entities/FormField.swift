//
//  FormField.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

// Base protocols
protocol BaseFieldProtocol {
    var type: FieldType! { get }
    var fieldId: String! { get }
    var label: String! { get set}
    var parentId: String? { get }
    var index: Int! { get }
    var answer: Any? { get set }
    var isError: Bool! { get set }
    var errorMessage: String! { get set }
    var rules: FieldRules? { get }
    var hidden: Bool! { get set }
    var disabled: Bool! { get set }

    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer?
    func getAnswerString() -> String
}

protocol SectionFieldProtocol: BaseFieldProtocol {
    var allowCollapse: Bool? { get }
    var defaultMode: String? { get }
    var icon: String? { get }
    var isExpandedStatus: Bool { get set }
}

class SectionField: SectionFieldProtocol {
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? { nil }
    func getAnswerString() -> String { "" }
    
    var allowCollapse: Bool?
    var defaultMode: String?
    var icon: String?
    var isExpandedStatus: Bool = false
    var type: FieldType!
    var fieldId: String!
    var label: String!
    var parentId: String?
    var index: Int!
    var answer: Any?
    var isError: Bool!
    var rules: FieldRules?
    var hidden: Bool!
    var disabled: Bool!
    var errorMessage: String!
    
    init(field: Field?) {
        guard let field = field else { return }
        
        // Initialize base properties
        self.type = field.type
        self.fieldId = field.id
        self.label = field.properties.label
        self.parentId = field.parentId
        self.index = 0
        self.isError = false
        self.rules = field.rules
        self.hidden = false
        self.disabled = false
        
        // Initialize interactive properties
        if let properties = field.properties as? SectionPropertiesProtocol {
            self.allowCollapse = properties.allowCollapse
            self.defaultMode = properties.defaultMode
            self.icon = properties.icon
        }
        
    }
}

protocol InteractiveFieldProtocol: BaseFieldProtocol {
    var required: Bool! { get }
    var placeHolder: String! { get }
    var note: String? { get set }
    var attachmentImages: [Any]? { get set }
    var attachmentFiles: [Any]? { get set }
    var sublabel: String? { get }
    var tooltip: String? { get }
    var addNote: Bool! { get set }
    var addAttachment: Bool! { get set }
    var attachmentType: AttachmentType! { get }
    var attachmentExtensions: String! { get }

    func isAnswered() -> Bool
}

// 2. Base implementation
struct InteractiveField: InteractiveFieldProtocol {
    // All the required properties
    var type: FieldType!
    var fieldId: String!
    var label: String!
    var parentId: String?
    var index: Int!
    var answer: Any?
    var isError: Bool!
    var errorMessage: String!
    var rules: FieldRules?
    var hidden: Bool!
    var disabled: Bool!
    var required: Bool!
    var placeHolder: String!
    var note: String?
    var attachmentImages: [Any]?
    var attachmentFiles: [Any]?
    var sublabel: String?
    var tooltip: String?
    var addNote: Bool!
    var addAttachment: Bool!
    var attachmentType: AttachmentType!
    var attachmentExtensions: String!

    init(field: Field?) {
        guard let field = field else { return }

        // Initialize base properties
        self.type = field.type
        self.fieldId = field.id
        self.label = field.properties.label
        self.sublabel = field.properties.sublabel
        self.parentId = field.parentId
        self.index = 0
        self.isError = false
        self.errorMessage = nil
        self.rules = field.rules
        self.hidden = false
        self.disabled = false

        // Initialize interactive properties
        if let properties = field.properties as? InteractivePropertiesProtocol {
            self.required = properties.required
            self.placeHolder = properties.placeholder
            self.sublabel = properties.sublabel
            self.tooltip = properties.tooltip
            self.addNote = properties.addNote ?? false
            self.addAttachment = properties.addAttachment ?? false
            self.attachmentType = properties.attachmentType ?? .both
            self.attachmentExtensions = properties.attachmentExtensions ?? ""
        }

        self.attachmentImages = []
        self.attachmentFiles = []
        self.note = nil
    }

    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? { nil }
    func getAnswerString() -> String { "" }
    func isAnswered() -> Bool { false }
}

// 3. Delegation protocol
protocol InteractiveFieldDelegate:  InteractiveFieldProtocol {
    var base: InteractiveField { get set }
}

// 4. Default implementations through protocol extension
extension InteractiveFieldDelegate {
    var type: FieldType! { base.type }
    var fieldId: String! { base.fieldId }
   // var label: String! { base.label }
    var parentId: String? { base.parentId }
    var index: Int! { base.index }
    var rules: FieldRules? { base.rules }
    var required: Bool! { base.required }
    var placeHolder: String! { base.placeHolder }
    var sublabel: String? { base.sublabel }
    var tooltip: String? { base.tooltip }
    var attachmentType: AttachmentType! { base.attachmentType }
    var attachmentExtensions: String! { base.attachmentExtensions }

    // Mutable properties
    var label: String! {
        get { base.label }
        set { base.label = newValue }
    }
    var answer: Any? {
        get { base.answer }
        set { base.answer = newValue }
    }
    var isError: Bool! {
        get { base.isError }
        set { base.isError = newValue }
    }
    var errorMessage: String! {
        get { base.errorMessage }
        set { base.errorMessage = newValue }
    }
    var hidden: Bool! {
        get { base.hidden }
        set { base.hidden = newValue }
    }
    var disabled: Bool! {
        get { base.disabled }
        set { base.disabled = newValue }
    }
    var note: String? {
        get { base.note }
        set { base.note = newValue }
    }
    var attachmentImages: [Any]? {
        get { base.attachmentImages }
        set { base.attachmentImages = newValue }
    }
    var attachmentFiles: [Any]? {
        get { base.attachmentFiles }
        set { base.attachmentFiles = newValue }
    }
    var addNote: Bool! {
        get { base.addNote }
        set { base.addNote = newValue }
    }
    var addAttachment: Bool! {
        get { base.addAttachment }
        set { base.addAttachment = newValue }
    }

    // Default implementations for methods
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? { base.handleSavedAnswer(sAnswer) }
    func getAnswerString() -> String { base.getAnswerString() }
    func isAnswered() -> Bool { base.isAnswered() }
}

class TextBase: InteractiveFieldDelegate {
    var base: InteractiveField

    let allowSpellCheck: Bool?
    let maximumLength: Int?
    let minimumLength: Int?
    let entryLimit: EntryLimit?

    init(field: Field?) {
        base = InteractiveField(field: field)

        if let properties = field?.properties as? TextBaseProperties {
            allowSpellCheck = properties.allowSpellcheck
            maximumLength = properties.maximumLength
            minimumLength = properties.minimumLength
            entryLimit = properties.entryLimit
        } else {
            allowSpellCheck = nil
            maximumLength = nil
            minimumLength = nil
            entryLimit = nil
        }
    }
}


protocol TextBaseDelegate: InteractiveFieldDelegate {
    var textBase: TextBase { get set }
}

extension TextBaseDelegate {
    var allowSpellCheck: Bool? { textBase.allowSpellCheck }
    var maximumLength: Int? { textBase.maximumLength }
    var minimumLength: Int? { textBase.minimumLength }
    var entryLimit: EntryLimit? { textBase.entryLimit }

    var base: InteractiveField {
        get { textBase.base }
        set { textBase.base = newValue }
    }
}


// 5. Implementation of specific field types becomes very clean
class TextBoxField: TextBaseDelegate {
    var textBase: TextBase

    // TextBox specific properties only
    let regex: String?
    let mask: String?
    let defaultAnswer: TextboxAnswer?
    let subType: TextBoxSubType?

    init(field: Field?) {
        textBase = TextBase(field: field)
        if let properties = field?.properties as? TextBoxProperties {
            regex = properties.regex
            mask = properties.mask
            defaultAnswer = properties.defaultAnswer
            subType = properties.subType
        } else {
            regex = nil
            mask = nil
            defaultAnswer = nil
            subType = nil
        }
    }

    // Override only what needs custom implementation
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        return nil
    }

    func getAnswerString() -> String {
        guard let answerValue = (answer as? TextboxAnswer)?.value else { return "" }
        return answerValue
    }

    func isAnswered() -> Bool {
        if let textValue = (answer as? BaseAnswerText)?.value, !textValue.isEmpty {
            return true
        }
        return false
    }
}

class PageField: BaseFieldProtocol {
    var type: FieldType!
    
    var fieldId: String!
    
    var label: String!
    
    var parentId: String?
    
    var index: Int!
    
    var answer: Any?
    
    var isError: Bool!

    var errorMessage: String!

    var rules: FieldRules?
    
    var hidden: Bool!
    
    var disabled: Bool!
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        return nil
    }
    
    func getAnswerString() -> String {
        return ""
    }

    init(field: Field?) {
        self.type = field?.type
        self.fieldId = field?.id ?? ""
        self.parentId = field?.parentId ?? ""
    }

}

class TextAreaField: TextBaseDelegate {
    var textBase: TextBase
    var fullScreen: Bool?
    var autoExpand: Bool?
    var defaultAnswer: TextAreaAnswer?

    init(field: Field?) {
        textBase = TextBase(field: field)

        //        if let properties = field.properties as? TextAreaProperties {
        //
        //        }
        fullScreen = nil
        autoExpand = nil
        defaultAnswer = nil
    }
}

class MCQBase: InteractiveFieldDelegate {
    var base: InteractiveField

    var options: [MCQOption]
    var defaultAnswer: BaseAnswerMCQ?
    var predefinedOptions: String?
    var shuffleOptions: Bool?
    var otherOption: Bool?
    var otherOptionText: String?
    var naOption: Bool?
    var naOptionText: String?

    init(field: Field?) {
        base = InteractiveField(field: field)

        if let properties = field?.properties as? MCQPropertiesProtocol {
            options = properties.options
            defaultAnswer = properties.defaultAnswer
            predefinedOptions = properties.predefinedOptions
            shuffleOptions = properties.shuffleOptions
            otherOption = properties.otherOption
            otherOptionText = properties.otherOptionText
            naOption = properties.naOption
            naOptionText = properties.naOptionText
        } else {
            options = []
            defaultAnswer = nil
            predefinedOptions = nil
            shuffleOptions = nil
            otherOption = nil
            otherOptionText = nil
            naOption = nil
            naOptionText = nil
        }
    }
}

protocol MCQBaseDelegate: InteractiveFieldDelegate {
    var mcqBase: MCQBase { get set }
}

extension MCQBaseDelegate {
    var defaultAnswer: BaseAnswerMCQ? { mcqBase.defaultAnswer }
    var predefinedOptions: String? { mcqBase.predefinedOptions }
    var shuffleOptions: Bool? { mcqBase.shuffleOptions }
    var otherOption: Bool? { mcqBase.otherOption }
    var otherOptionText: String? { mcqBase.otherOptionText }
    var naOption: Bool? { mcqBase.naOption }
    var naOptionText: String? { mcqBase.naOptionText }

    var options: [MCQOption] {
        get { mcqBase.options }
        set { mcqBase.options = newValue }
    }

    var base: InteractiveField {
        get { mcqBase.base }
        set { mcqBase.base = newValue }
    }
}

class RadioButtonField: MCQBaseDelegate,Equatable {
    var mcqBase: MCQBase

    init(field: Field?) {
        mcqBase = MCQBase(field: field)
    }
    static func == (lhs: RadioButtonField, rhs: RadioButtonField) -> Bool {
        return lhs.options.elementsEqual(rhs.options) { $0 == $1 }
    }
}
