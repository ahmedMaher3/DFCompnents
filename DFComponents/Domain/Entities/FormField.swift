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
//    var localization: BaseLocalization? { get set }
    
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

// Base structs
struct FormViewModelItem: FormViewModelItemProtocol {
    var type: FieldType!
    var fieldId: String!
    var label: String!
    var parentId: String?
    var index: Int!
    var answer: Any?
    var isError: Bool!
    var rules: FieldRules?
    var hidden: Bool! = false
    var disabled: Bool! = false
//    var localization: BaseLocalization?
    
    init(field: Field?) {
        if let field = field {
            type = field.type
            fieldId = field.id
            parentId = field.parentId
            label = field.properties.label
//            answer = field.answer
            isError = false
            rules = field.rules
            hidden = false
            disabled = false
//            localization = field.properties?.localization
        }
    }
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        print(sAnswer ?? "")
        return nil
    }
    
    func getAnswerString() -> String {
        return ""
    }
}

struct FormViewModelInteractiveItem: InteractiveItemProtocol {
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
//    var localization: BaseLocalization?
    
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
        if let properties = field?.properties as? InteractivePropertiesProtocol {
            required = properties.required
            placeHolder = properties.placeholder
            sublabel = properties.subLabel
            tooltip = properties.tooltip
//            if let localization = properties.localization as? InteractiveLocalization {
//                self.localization = localization
//            }
            addNote = properties.addNote ?? false
            addAttachment = properties.addAttachment ?? false
            attachmentType = properties.attachmentType ?? .both
            attachmentExtensions = properties.attachmentExtensions ?? ""
        }
        attachmentImages = []
        attachmentFiles = []
        note = ""
        
        // Initialize base properties
        if let field = field {
            type = field.type
            fieldId = field.id
            parentId = field.parentId
            label = field.properties.label
//            answer = field.answer
            isError = false
            rules = field.rules
            hidden = false
            disabled = false
        }
    }
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        print(sAnswer ?? "")
        return nil
    }
    
    func getAnswerString() -> String {
        return ""
    }
    
    func isAnswered() -> Bool {
        return false
    }
}

// Example of a specific form item
struct FormViewModelTextBoxItem: FormViewModelItemProtocol, InteractiveItemProtocol {
    private var base: FormViewModelInteractiveItem
    var regex: String?
//    var prefix: PrefixViewModel?
//    var suffix: PrefixViewModel?
    var mask: String?
    var defaultAnswer: TextboxAnswer?
    var subType: TextBoxSubType?
    
    // Delegate properties from FormViewModelItemProtocol
    var type: FieldType! { get { base.type } }
    var fieldId: String! { get { base.fieldId } }
    var label: String! { get { base.label } }
    var parentId: String? { get { base.parentId } }
    var index: Int! { get { base.index } }
    var answer: Any? { get { base.answer } set { base.answer = newValue } }
    var isError: Bool! { get { base.isError } set { base.isError = newValue } }
    var rules: FieldRules? { get { base.rules } }
    var hidden: Bool! { get { base.hidden } set { base.hidden = newValue } }
    var disabled: Bool! { get { base.disabled } set { base.disabled = newValue } }
//    var localization: BaseLocalization? { get { base.localization } set { base.localization = newValue } }
    
    // Delegate properties from InteractiveItemProtocol
    var required: Bool! { get { base.required } }
    var placeHolder: String! { get { base.placeHolder } }
    var note: String? { get { base.note } set { base.note = newValue } }
    var attachmentImages: [Any]? { get { base.attachmentImages } set { base.attachmentImages = newValue } }
    var attachmentFiles: [Any]? { get { base.attachmentFiles } set { base.attachmentFiles = newValue } }
    var sublabel: String? { get { base.sublabel } }
    var tooltip: String? { get { base.tooltip } }
    var addNote: Bool! { get { base.addNote } set { base.addNote = newValue } }
    var addAttachment: Bool! { get { base.addAttachment } set { base.addAttachment = newValue } }
    var attachmentType: AttachmentType! { get { base.attachmentType } }
    var attachmentExtensions: String! { get { base.attachmentExtensions } }
    
    init(field: Field?) {
        base = FormViewModelInteractiveItem(field: field)
        
        if let properties = field?.properties as? TextBoxProperties {
//            prefix = PrefixViewModel(prefix: properties.prefix)
//            suffix = PrefixViewModel(prefix: properties.suffix)
            mask = properties.mask
            defaultAnswer = properties.defaultAnswer
            subType = properties.subType
        }
    }
    
    func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
//        if let valueObject = sAnswer as? JSON {
//            return TextboxAnswer(JSON: valueObject)
//        }
        return nil
    }
    
    func getAnswerString() -> String {
        guard let answerValue = (answer as? TextboxAnswer)?.value else {
            return ""
        }
        return answerValue
    }
    
    func isAnswered() -> Bool {
        if let textValue = (answer as? BaseAnswerText)?.value, !textValue.isEmpty {
            return true
        }
        return false
    }
}
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
        let item = FormViewModelItem(field: nil)
        items.append(item)
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
