//
//  FormField.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

// Base protocols
protocol FormViewModelItemProtocol {
    var type: FieldType! { get }
    var fieldId: String! { get }
    var label: String! { get }
    var parentId: String? { get }
    var index: Int! { get }
    var answer: Any? { get set }
    var isError: Bool! { get set }
    var rules: FieldRules? { get }
    var hidden: Bool! { get set }
    var disabled: Bool! { get set }
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer?
    func getAnswerString() -> String
}

protocol InteractiveItemProtocol: FormViewModelItemProtocol {
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
struct InteractiveFieldBase: FormViewModelItemProtocol, InteractiveItemProtocol {
    // All the required properties
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
        self.parentId = field.parentId
        self.index = 0
        self.isError = false
        self.rules = field.rules
        self.hidden = false
        self.disabled = false
        
        // Initialize interactive properties
        if let properties = field.properties as? InteractivePropertiesProtocol {
            self.required = properties.required
            self.placeHolder = properties.placeholder
            self.sublabel = properties.subLabel
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
protocol InteractiveFieldDelegate: FormViewModelItemProtocol, InteractiveItemProtocol {
    var base: InteractiveFieldBase { get set }
}

// 4. Default implementations through protocol extension
extension InteractiveFieldDelegate {
    var type: FieldType! { base.type }
    var fieldId: String! { base.fieldId }
    var label: String! { base.label }
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
    var answer: Any? {
        get { base.answer }
        set { base.answer = newValue }
    }
    var isError: Bool! {
        get { base.isError }
        set { base.isError = newValue }
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

struct TextBaseItem: InteractiveFieldDelegate {
    var base: InteractiveFieldBase
    
    let allowSpellCheck: Bool?
    let maximumLength: Int?
    let minimumLength: Int?
    let entryLimit: EntryLimit?
    
    init(field: Field?) {
        base = InteractiveFieldBase(field: field)
        
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

protocol TextBaseItemDelegate: InteractiveFieldDelegate {
    var textBase: TextBaseItem { get set }
}

extension TextBaseItemDelegate {
    var allowSpellCheck: Bool? { textBase.allowSpellCheck }
    var maximumLength: Int? { textBase.maximumLength }
    var minimumLength: Int? { textBase.minimumLength }
    var entryLimit: EntryLimit? { textBase.entryLimit }
    
    var base: InteractiveFieldBase {
        get { textBase.base }
        set { textBase.base = newValue }
    }
}

// 5. Implementation of specific field types becomes very clean
struct FormViewModelTextBoxItem: TextBaseItemDelegate {
    var textBase: TextBaseItem
    
    // TextBox specific properties only
    let regex: String?
    let mask: String?
    let defaultAnswer: TextboxAnswer?
    let subType: TextBoxSubType?
    
    init(field: Field?) {
        textBase = TextBaseItem(field: field)
        
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
//        guard let valueObject = sAnswer as? TextboxAnswer else { return nil }
//        return valueObject
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

struct FormViewModelTextAreaItem: TextBaseItemDelegate {
    var textBase: TextBaseItem
    
    var fullScreen: Bool?
    var autoExpand: Bool?
//    var editorType: EditorType!
    var defaultAnswer: TextAreaAnswer?
    
    init(field: Field?) {
        textBase = TextBaseItem(field: field)
        
//        if let properties = field.properties as? TextAreaProperties {
//            
//        }
        fullScreen = nil
        autoExpand = nil
        defaultAnswer = nil
    }
}

//// Example of a specific form item
//struct FormViewModelTextBoxItem: FormViewModelItemProtocol, InteractiveItemProtocol {
//    private var base: FormViewModelInteractiveItem
//    var regex: String?
////    var prefix: PrefixViewModel?
////    var suffix: PrefixViewModel?
//    var mask: String?
//    var defaultAnswer: TextboxAnswer?
//    var subType: TextBoxSubType?
//    
//    // Delegate properties from FormViewModelItemProtocol
//    var type: FieldType! { get { base.type } }
//    var fieldId: String! { get { base.fieldId } }
//    var label: String! { get { base.label } }
//    var parentId: String? { get { base.parentId } }
//    var index: Int! { get { base.index } }
//    var answer: Any? { get { base.answer } set { base.answer = newValue } }
//    var isError: Bool! { get { base.isError } set { base.isError = newValue } }
//    var rules: FieldRules? { get { base.rules } }
//    var hidden: Bool! { get { base.hidden } set { base.hidden = newValue } }
//    var disabled: Bool! { get { base.disabled } set { base.disabled = newValue } }
////    var localization: BaseLocalization? { get { base.localization } set { base.localization = newValue } }
//    
//    // Delegate properties from InteractiveItemProtocol
//    var required: Bool! { get { base.required } }
//    var placeHolder: String! { get { base.placeHolder } }
//    var note: String? { get { base.note } set { base.note = newValue } }
//    var attachmentImages: [Any]? { get { base.attachmentImages } set { base.attachmentImages = newValue } }
//    var attachmentFiles: [Any]? { get { base.attachmentFiles } set { base.attachmentFiles = newValue } }
//    var sublabel: String? { get { base.sublabel } }
//    var tooltip: String? { get { base.tooltip } }
//    var addNote: Bool! { get { base.addNote } set { base.addNote = newValue } }
//    var addAttachment: Bool! { get { base.addAttachment } set { base.addAttachment = newValue } }
//    var attachmentType: AttachmentType! { get { base.attachmentType } }
//    var attachmentExtensions: String! { get { base.attachmentExtensions } }
//    
//    init(field: Field?) {
//        base = FormViewModelInteractiveItem(field: field)
//        
//        if let properties = field?.properties as? TextBoxProperties {
////            prefix = PrefixViewModel(prefix: properties.prefix)
////            suffix = PrefixViewModel(prefix: properties.suffix)
//            mask = properties.mask
//            defaultAnswer = properties.defaultAnswer
//            subType = properties.subType
//        }
//    }
//    
//    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
////        if let valueObject = sAnswer as? JSON {
////            return TextboxAnswer(JSON: valueObject)
////        }
//        return nil
//    }
//    
//    func getAnswerString() -> String {
//        guard let answerValue = (answer as? TextboxAnswer)?.value else {
//            return ""
//        }
//        return answerValue
//    }
//    
//    func isAnswered() -> Bool {
//        if let textValue = (answer as? BaseAnswerText)?.value, !textValue.isEmpty {
//            return true
//        }
//        return false
//    }
//}
//struct FormViewModelTextBoxItem {
//    private var base: FormViewModelInteractiveItem
//    var regex: String?
////    var prefix: PrefixViewModel?
////    var suffix: PrefixViewModel?
//    var mask: String?
//    var defaultAnswer: TextboxAnswer?
//    var subType: TextBoxSubType?
//    
//    init(field: Field?) {
//        base = FormViewModelInteractiveItem(field: field)
//        
//        if let properties = field?.properties as? TextBoxProperties {
////            prefix = PrefixViewModel(prefix: properties.prefix)
////            suffix = PrefixViewModel(prefix: properties.suffix)
//            mask = properties.mask
//            defaultAnswer = properties.defaultAnswer
//            subType = properties.subType
//        }
//    }
//}

// Main ViewModel struct
struct FormEntity {
    var items = [FormViewModelItemProtocol]()
    var rules: [Rule]?
//    var warnings: Warning?
    
    init(_ form: Schema) {
        for field in form.fields {
            switch field.type {
            case .TextBox:
                let item = FormViewModelTextBoxItem(field: field)
                items.append(item)
            // ... handle other cases similarly
            default:
                break
            }
        }
        self.rules = form.rules
//        self.warnings = form.warnings
    }
    
    mutating func appendSubmitItem() {
//        let item = FormViewModelItem(field: nil)
//        items.append(item)
    }
    
    // Helper methods for managing form items
    func getItem(by id: String) -> FormViewModelItemProtocol? {
        return items.first { $0.fieldId == id }
    }
    
    mutating func updateItem(_ item: FormViewModelItemProtocol?) {
        guard let item else { return }
        guard let index = items.firstIndex(where: { $0.fieldId == item.fieldId }) else { return }
        updateItem(at: index, with: item)
    }
    
    mutating func updateItem(at index: Int, with item: FormViewModelItemProtocol) {
        guard index < items.count else { return }
        items[index] = item
    }
    
    func validateAll() -> Bool {
        return items.allSatisfy { item in
            // Add your validation logic here
            guard let interactive = item as? InteractiveItemProtocol else { return true }
            return !interactive.required || interactive.isAnswered()
        }
    }
}

extension FormEntity {
    // Helper method to get typed items
    func getTextBoxItem(by id: String) -> FormViewModelTextBoxItem? {
        return getItem(by: id) as? FormViewModelTextBoxItem
    }
    
    // Add more helper methods for other types
//    func getDropdownItem(by id: String) -> FormViewModelDropdownItem? {
//        return getItem(by: id) as? FormViewModelDropdownItem
//    }
}

extension FormEntity {
    mutating func updateAnswer(for id: String, with answer: Any) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].answer = answer
        }
    }
    
    func getAnswerString(for id: String) -> String? {
        return getItem(by: id)?.getAnswerString()
    }
    
    mutating func hideField(_ id: String) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].hidden = true
        }
    }
    
    mutating func showField(_ id: String) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].hidden = false
        }
    }
}

//protocol FormFieldProtocol {
//    var type: FieldType! { get }
//    var fieldId: String! { get }
//    var label: String! { get }
//    var answer: Any? { get set }
//    var isError: Bool! { get set }
////    let rules: FieldRule?
//    var hidden: Bool { get set }
//    var disabled: Bool { get set }
//}
//
//protocol InteractiveFormFieldProtocol: FormFieldProtocol {
//    var required: Bool! { get }
//    var placeHolder: String! { get }
//    var note: String? { get set }
//    var attachmentImages: [Any]? { get set }
//    var attachmentFiles: [Any]? { get set }
//    var sublabel: String? { get }
//    var tooltip: String? { get }
//    var addNote: Bool! { get set }
//    var addAttachment: Bool! { get set }
//    var attachmentType: AttachmentType! { get }
//    var attachmentExtensions: String! { get }
//}
//
//protocol TextBaseFormFieldProtocol: InteractiveFormFieldProtocol {
//    var allowSpellCheck: Bool? { get }
//    var maximumLength: Int? { get }
//    var minimumLength: Int? { get }
//    var entryLimit: EntryLimit? { get }
//}
//
//struct TextBoxFormField: TextBaseFormFieldProtocol {
//    var allowSpellCheck: Bool?
//    
//    var maximumLength: Int?
//    
//    var minimumLength: Int?
//    
//    var entryLimit: EntryLimit?
//    
//    var required: Bool!
//    
//    var placeHolder: String!
//    
//    var note: String?
//    
//    var attachmentImages: [Any]?
//    
//    var attachmentFiles: [Any]?
//    
//    var sublabel: String?
//    
//    var tooltip: String?
//    
//    var addNote: Bool!
//    
//    var addAttachment: Bool!
//    
//    var attachmentType: AttachmentType!
//    
//    var attachmentExtensions: String!
//    
//    var type: FieldType!
//    
//    var fieldId: String!
//    
//    var label: String!
//    
//    var answer: Any?
//    
//    var isError: Bool!
//    
//    var hidden: Bool
//    
//    var disabled: Bool
//    
//    
//}
//
//struct FormField: FormFieldProtocol {
//    let type: FieldType!
//    let fieldId: String!
//    let label: String!
//    var answer: Any?
//    var isError: Bool!
//    var hidden: Bool = false
//    var disabled: Bool = false
//}

//struct FormField: Identifiable {
//    let id: String
//    let type: FieldType
//    let label: String
//    let sublabel: String?
//    var value: String?
////    let isRequired: Bool
//    let properties: BaseProperties?
//    var isVisible: Bool
//    let rules: FieldRules?
//    var field: Field  // Add the `field` property, which holds the actual Field
//
//    init(field: Field) {
//        id = field.id ?? ""
//        type = field.type
//        label = field.properties.label ?? ""
//        sublabel = field.properties.subLabel ?? ""
//        value = ""
////        isRequired = field.properties.required ?? false
//        properties = field.properties
//        isVisible = true
//        rules = field.rules
//        self.field = field
//    }
//}
