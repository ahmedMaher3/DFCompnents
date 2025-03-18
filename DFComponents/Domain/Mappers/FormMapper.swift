//
//  FormMapper.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation
import SwiftUICore

protocol EntityMapper {
    associatedtype DTO
    func map (from dto: DTO) -> [PageModel]
    associatedtype Warnings
    func map (from dto: Warnings) -> WarningsEntity
}

class FormMapper: EntityMapper {

    typealias DTO = Schema
    typealias formWarnings = WarningsEntity

    func map(from dto: Schema) -> [PageModel] {
        let pages = convertToPages(fields: dto.fields,
                                   mode: dto.settings.format )
        return pages
    }

    private func convertToPages(fields: [Field], mode: FormType) -> [PageModel] {
        return mode == .classic ? convertToPagesInClassicMode(fields: fields, mode: mode) : convertToPagesInCardsMode(fields: fields, mode: mode)
    }
    
    func convertToPagesInClassicMode(fields: [Field], mode: FormType) -> [PageModel] {
        let pagesData = fields.filter { $0.type == .page } // Extract page fields
        
        let groupedFields = Dictionary(grouping: fields.filter { $0.parentId != nil }) { $0.parentId! }

        // 🔹 Recursively process pages & sections
        let pages = pagesData.compactMap { page -> PageModel? in
            guard let pageId = page.id else { return nil }
            let mappedFields = mapFieldsRecursively(fields: groupedFields[pageId] ?? [], groupedFields: groupedFields)

            let control = PageField(field: page)
            let pageRenderer = PageRenderer(field: control, controls: mappedFields)

            return PageModel(
                pageField: pageRenderer,
                id: pageId,
                fields: mappedFields,
                mode: mode
            )
        }

        return pages
    }

    private func convertToPagesInCardsMode(fields: [Field], mode: FormType) -> [PageModel] {
        var pages: [PageModel] = []
        var cardIndex = 1

        let cardFields = fields.filter { $0.type != .page && $0.type != .section }

        for field in cardFields {
            let pageId = "page_\(cardIndex)"

            let mappedFields = mapFieldsRecursively(fields: [field], groupedFields: [:])

            let control = PageField(field: field)
            let pageRenderer = PageRenderer(field: control, controls: mappedFields)

            let pageModel = PageModel(
                pageField: pageRenderer,
                id: pageId,
                fields: mappedFields,
                mode: mode
            )
            
            pages.append(pageModel)

            cardIndex += 1
        }

        return pages
    }

    // 🔹 Recursive function to map fields & handle sections dynamically
    private func mapFieldsRecursively(fields: [Field], groupedFields: [String: [Field]]) -> [any FieldRenderable] {
        return fields.compactMap { field in
            if field.type == .section {
                let sectionControls = mapFieldsRecursively(fields: groupedFields[field.id!] ?? [], groupedFields: groupedFields)
                let control = SectionField(field: field)
                return SectionButtonRenderer(field: control,controls:sectionControls)
               // return .section((control, SectionViewModel(controls: sectionControls, sectionField: control)))
            }
            return mapSingleField(field: field)
        }
    }

    // 🔹 Helper Function to Map a Single Field

    private func mapSingleField(field: Field) ->  (any FieldRenderable)? {
        switch field.type {
            case .textBox:
            let control = TextBoxField(field: field)
            return TextBoxRenderer(field: control)

            case .radio:
            let control = RadioButtonField(field: field)
            return RadioButtonRenderer(field: control)

            case .number:
                let control = NumberField(field: field)
            return NumberFieldRenderer(field: control)
            
            default:
                return nil
        }
    }


//    private func mapSingleField(field: Field) -> FieldEntity? {
//        switch field.type {
//            case .textBox:
//                let control = TextBoxField(field: field)
//                return .textBox((control, TextBoxViewModel(control: control)))
//            case .radio:
//                let control = RadioButtonField(field: field)
//                return .radio((control, RadioButtonViewModel(control: control)))
//            case .number:
//                let control = NumberField(field: field)
//                return .number((control, NumberFieldViewModel(numberFieldModel: control)))
//            default:
//                return nil
//        }
//    }

    func map(from dto: Warnings) -> WarningsEntity {
        return WarningsEntity(
            formValidation: FormValidationEntity(
                expired: dto.formWarning.formValidation.expired,
                notAvailable: dto.formWarning.formValidation.notAvailable,
                multipleSubmission: dto.formWarning.formValidation.multipleSubmission,
                notStarted: dto.formWarning.formValidation.notStarted
            ),
            fieldValidation: FieldValidationEntity(
                emptyForm: dto.formWarning.fieldValidation.emptyForm,
                required: dto.formWarning.fieldValidation.required,
                maxAttachment: dto.formWarning.fieldValidation.maxAttachment,
                input: InputValidationEntity(
                    minimumCharacterLength:
                        dto.formWarning.fieldValidation.input.minimumCharacterLength,
                    maximumCharacterLength: dto.formWarning.fieldValidation.input.maximumCharacterLength,
                    minimumWordLength: dto.formWarning.fieldValidation.input.minimumWordLength,
                    maximumWordLength: dto.formWarning.fieldValidation.input.maximumWordLength,
                    email: dto.formWarning.fieldValidation.input.email,
                    url: dto.formWarning.fieldValidation.input.url,
                    numeric: dto.formWarning.fieldValidation.input.numeric,
                    alphabetic: dto.formWarning.fieldValidation.input.alphabetic,
                    alphanumeric: dto.formWarning.fieldValidation.input.alphanumeric,
                    custom: dto.formWarning.fieldValidation.input.custom
                ),
                number: NumberValidationEntity(
                    minimumValue: dto.formWarning.fieldValidation.number.minimumValue,
                    maximumValue: dto.formWarning.fieldValidation.number.maximumValue,
                    minimumDigits: dto.formWarning.fieldValidation.number.minimumDigits,
                    maximumDigits: dto.formWarning.fieldValidation.number.maximumDigits
                ),
                dateTime: DateTimeValidationEntity(
                    dateTime: dto.formWarning.fieldValidation.dateTime.dateTime,
                    dateRange: dto.formWarning.fieldValidation.dateTime.dateRange
                ),
                mcq: MCQValidationEntity(
                    minimumNumberOfSelectedOptions: dto.formWarning.fieldValidation.mcq.minimumNumberOfSelectedOptions,
                    maximumNumberOfSelectedOptions: dto.formWarning.fieldValidation.mcq.maximumNumberOfSelectedOptions
                ),
                fileUpload: FileUploadValidationEntity(
                    maxFilesSize: dto.formWarning.fieldValidation.fileUpload.maxFilesSize,
                    maxSizePerFile: dto.formWarning.fieldValidation.fileUpload.maxSizePerFile,
                    minNumberOfFiles: dto.formWarning.fieldValidation.fileUpload.minNumberOfFiles,
                    maxNumberOfFiles: dto.formWarning.fieldValidation.fileUpload.maxNumberOfFiles,
                    allowedExtensions: dto.formWarning.fieldValidation.fileUpload.allowedExtensions,
                    invalidLink: dto.formWarning.fieldValidation.fileUpload.invalidLink
                ),
                location: LocationValidationEntity(
                    maximumLocations: dto.formWarning.fieldValidation.location.maximumLocations,
                    minimumLocations: dto.formWarning.fieldValidation.location.minimumLocations,
                    notInRange: dto.formWarning.fieldValidation.location.notInRange
                )
            )
        )
    }

}

struct PageModel: Identifiable { // [Page Model]
    var pageField: (any PageRenderable)?
    var id: String
    var fields: [any FieldRenderable]
    var mode: FormType
}

enum FieldEntity: Identifiable {
    case textBox((BaseFieldProtocol, TextBoxViewModel))
    case radio((BaseFieldProtocol, RadioButtonViewModel))
    case page((BaseFieldProtocol, PageViewModel))
    case section((BaseFieldProtocol, SectionViewModel))
    case number((BaseFieldProtocol, NumberFieldViewModel))

    private var baseField: BaseFieldProtocol {
        switch self {
            case .textBox((let field, _)),
                    .radio((let field, _)),
                    .page((let field, _)),
                    .section((let field, _)),
                    .number((let field, _)):
                return field
        }
    }

    var value: String? {
        get {
            switch self {
                case .textBox((let field, _)),
                        .radio((let field, _)),
                        .page((let field, _)),
                        .section((let field, _)),
                        .number((let field, _)):
                    return field.answer as? String
            }
        }
        set {
            guard let newValue = newValue else { return }
            switch self {
                case .textBox((var field, let id)):
                    field.answer = newValue
                    self = .textBox((field, id))

                case .radio((var field, let id)):
                    field.answer = newValue
                    self = .radio((field, id))

                case .page((var field, let id)):
                    field.answer = newValue
                    self = .page((field, id))

                case .section((var field, let id)):
                    field.answer = newValue
                    self = .section((field, id))

                case .number((var field, let id)):
                    field.answer = newValue
                    self = .number((field, id))
            }
        }
    }

    var id: String { baseField.fieldId }

    var parentId: String? { baseField.parentId }

    var type: FieldType { baseField.type }

    var errorMessage: String? { baseField.errorMessage }
    
    var validatorField: FieldValidationStrategy? {
        switch self {
            case .number:
                return NumberValidationStrategy()
            default:
                return nil
        }
    }

    var validateViewModel: ValidateFieldStrategy? {
        switch self {
            case .number((_, let viewModel)):
                return viewModel
            case .textBox((_,_)):
                break
            case .radio((_,_)):
                break
            case .page((_,_)):
                break
            case .section((_,_)):
                break
        }
        return nil
    }
}


protocol BaseViewModel {

}

protocol FieldRenderable {
    associatedtype Field: BaseFieldProtocol
    associatedtype ViewModel: BaseViewModel

    var field: Field { get }
    var viewModel: ViewModel { get }

    var id: String { get }
    var errorMessage: String? { get }

    func render() -> AnyView
    func renderHeader() -> AnyView
}
    
protocol PageRenderable: FieldRenderable {
    func renderPage(viewModel: FormViewModel, index: Int) -> AnyView
}

struct RadioButtonRenderer: FieldRenderable {

    var field: RadioButtonField
    var viewModel: RadioButtonViewModel


    init(field: RadioButtonField) {
        self.field = field
        self.viewModel = RadioButtonViewModel(control: field)
     }

   var id: String { field.fieldId}
   var errorMessage: String? { field.errorMessage }


    func render() -> AnyView {
        //guard let radioField = field  else { return AnyView(EmptyView()) }
        return AnyView(RadioButtonView(radioButtonVM: RadioButtonViewModel(control: field)))
    }

    func renderHeader() -> AnyView {
        return AnyView(EmptyView())
    }


}

struct TextBoxRenderer: FieldRenderable {

    var field: TextBoxField
    var viewModel: TextBoxViewModel


    init(field: TextBoxField) {
        self.field = field
        self.viewModel = TextBoxViewModel(control: field)
    }
    var id: String { field.fieldId}
    var errorMessage: String? { field.errorMessage }

    func render() -> AnyView {
      //  guard let textBoxField = field  else { return AnyView(EmptyView())}
        return AnyView(TextBoxComponent(viewModel: TextBoxViewModel(control: field)))
    }

    func renderHeader() -> AnyView {

        return AnyView(EmptyView())
    }
    
}

struct NumberFieldRenderer: FieldRenderable {
    var field: NumberField
    var viewModel: NumberFieldViewModel


    init(field: NumberField) {
        self.field = field
        self.viewModel = NumberFieldViewModel(numberFieldModel: field)
    }
    var id: String { field.fieldId}
    var errorMessage: String? { field.errorMessage }

    func render() -> AnyView {
//        guard let numberField = field else { return AnyView(EmptyView()) }
        return AnyView(NumberFieldComponent(viewModel: NumberFieldViewModel(numberFieldModel: field)))
    }

    func renderHeader() -> AnyView {
       let viewModel = NumberFieldViewModel(numberFieldModel: field )
        let properties = viewModel.numberFieldModel.basePropertiesNotInteractive
       return AnyView(labelView(baseProperties: properties))
    }

}

struct PageRenderer: PageRenderable {
    
    var field: PageField
    var viewModel: PageViewModel
    // Concrete Class

    var controls: [any FieldRenderable]!

    init(field: PageField,controls: [any FieldRenderable]) {
        self.field = field
        self.controls = controls
        self.viewModel = PageViewModel(controls: controls, pageField: field)
    }
    var id: String { field.fieldId}
    var errorMessage: String? { field.errorMessage }
    
    func render() -> AnyView {

        return AnyView(PageView(pageViewModel: PageViewModel(controls: controls, pageField: field)))
            //.environmentObject(viewModel)
    }
    
    func renderPage(viewModel: FormViewModel, index: Int) -> AnyView {
        return AnyView(PageView(pageViewModel: PageViewModel(controls: controls, pageField: field)).environmentObject(viewModel).tag(index))
    }

    func renderHeader() -> AnyView {
        return AnyView(EmptyView())
    }

}

struct SectionButtonRenderer: FieldRenderable { // Concrete Class

    var field: SectionField
    var controls: [any FieldRenderable]!
    var viewModel: SectionViewModel




    init(field: SectionField,controls: [any FieldRenderable]) {
        self.field = field
        self.controls = controls
        self.viewModel = SectionViewModel(controls: controls, sectionField: field)
    }
    var id: String { field.fieldId}
    var errorMessage: String? { field.errorMessage }
    
    func render() -> AnyView {

        return AnyView(SectionView(sectionViewModel: SectionViewModel(controls: controls, sectionField: field), isExpanded: false))
    }

    func renderHeader() -> AnyView {
        return AnyView(EmptyView())
    }


}


