//
//  FormMapper.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol EntityMapper {
    associatedtype DTO
    associatedtype Entity
    func map (from dto: DTO) -> [PageModel]
    associatedtype Warnings
    //    func map (from dto: DTO) -> [FieldEntity]
    func map (from dto: Warnings) -> WarningsEntity
}

class FormMapper: EntityMapper {
    
    //    func map(from dto: Schema) -> [FieldEntity] {
    //        <#code#>
    //    }
    
    
    typealias DTO = Schema
    typealias Entity = FieldEntity
    typealias formWarnings = WarningsEntity
    
    func map(from dto: Schema) -> [PageModel] {
        let pages = convertToPages(fields: dto.fields,
                                   mode: dto.settings.format )
        return pages
    }
    
    private func convertToPages(fields: [Field], mode: FormType) -> [PageModel] {
        return mode == .classic ? convertToPagesInClassicMode(fields: fields, mode: mode) : convertToPagesInCardsMode(fields: fields, mode: mode)
    }
    
    //    func groupFieldsByPage(fields: [Field], mode: FormType) -> [PageModel] {
    //        let pageIds = fields.compactMap { $0.type == .page ? $0.id : nil }
    //
    //        let groupedFields = Dictionary(grouping: fields.filter{$0.parentId != nil}) { field in
    //
    //            field.parentId.flatMap { pageIds.contains($0) ? $0 : nil }
    //        }
    //        //let pages = groupedFields.map { PageModel(id: $0.key!, fields: mapFields(fields: $0.value)) }
    //        let pages = groupedFields.map { (key, value) in
    //            let mappedFields = mapFields(fields: value)
    //
    //            // 🔹 Debug: Print the mapping process
    //            print("Mapping for Page ID:", key ?? "Unknown", "Mapped Fields:", mappedFields)
    //
    //            return PageModel(id: key ?? "", fields: mappedFields, mode: mode)
    //        }
    //
    //        return pages
    //    }
    
    //    func mapFields(fields: [Field]) -> [FieldEntity] {
    //        return fields.compactMap { field in
    //            switch field.type {
    //            case .textBox:
    //                let control = TextBoxField(field: field)
    //                return .textBox((control, TextBoxViewModel(control: control)))
    //            case .radio:
    //                let control = RadioButtonField(field: field)
    //                return .radio((control, RadioButtonViewModel(control: control)))
    //            case .page:
    //                let control = PageField(field: field)
    //                return .page((control, PageViewModel()))
    //            case .section:
    //                let control = SectionField(field: field)
    //                return .section((control, SectionViewModel(controls: [], title: "title")))
    //            case .number:
    //                let control = NumberFieldModel(field: field)
    //                return .number((control, NumberFieldViewModel(numberFieldModel: control)))
    //
    //            default:
    //                return nil
    //            }
    //        }
    //    }
    
    func convertToPagesInClassicMode(fields: [Field], mode: FormType) -> [PageModel] {
        let pageIds = fields.compactMap { $0.type == .page ? $0.id : nil } // collect pageIds
        
        let groupedFields = Dictionary(grouping: fields.filter { $0.parentId != nil }) { $0.parentId! } // Collect fields with same parent id in group
        
        // 🔹 Recursively process pages & sections
        let pages = pageIds.compactMap { pageId -> PageModel? in
            guard let pageFields = groupedFields[pageId] else { return nil }
            let mappedFields = mapFieldsRecursively(fields: pageFields, groupedFields: groupedFields)
            return PageModel(id: pageId, fields: mappedFields, mode: mode)
        }
        
        return pages
    }
    
    private func convertToPagesInCardsMode(fields: [Field], mode: FormType) -> [PageModel] {
        var pages: [PageModel] = []
        var cardIndex = 1
        
        let cardFields = fields.filter { $0.type != .page && $0.type != .section } // Exclude pages & sections
        
        for field in cardFields {
            let pageId = "page_\(cardIndex)" // Manually assigning unique page IDs
            
            let mappedFields = mapFieldsRecursively(fields: [field], groupedFields: [:]) // Map single field
            
            let pageModel = PageModel(id: pageId, fields: mappedFields, mode: mode)
            pages.append(pageModel)
            
            cardIndex += 1
        }
        
        return pages
    }
    
    // 🔹 Recursive function to map fields & handle sections dynamically
    private func mapFieldsRecursively(fields: [Field], groupedFields: [String: [Field]]) -> [FieldEntity] {
        return fields.compactMap { field in
            if field.type == .section {
                let sectionControls = mapFieldsRecursively(fields: groupedFields[field.id!] ?? [], groupedFields: groupedFields)
                let control = SectionField(field: field)
                return .section((control, SectionViewModel(controls: sectionControls, title: field.properties.label ?? "Section")))
            }
            return mapSingleField(field: field)
        }
    }
    
    // 🔹 Helper Function to Map a Single Field
    private func mapSingleField(field: Field) -> FieldEntity? {
        switch field.type {
        case .textBox:
            let control = TextBoxField(field: field)
            return .textBox((control, TextBoxViewModel(control: control)))
        case .radio:
            let control = RadioButtonField(field: field)
            return .radio((control, RadioButtonViewModel(control: control)))
        case .number:
            let control = NumberFieldModel(field: field)
            return .number((control, NumberFieldViewModel(numberFieldModel: control)))
        default:
            return nil
        }
    }
    
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
                    minimumCharacterLength: dto.formWarning.fieldValidation.input.minimumCharacterLength,
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

struct PageModel: Identifiable {
    var id: String
    var fields: [FieldEntity]
    var mode: FormType
}

enum FieldEntity: Identifiable {
    case textBox((BaseFieldProtocol, TextBoxViewModel))
    case radio((BaseFieldProtocol, RadioButtonViewModel))
    case page((BaseFieldProtocol, PageViewModel))
    case section((BaseFieldProtocol, SectionViewModel))
    case number((BaseFieldProtocol, NumberFieldViewModel))
    
    var id: String {
        switch self {
        case .page((let field, _)):
            return field.fieldId
        case .textBox((let field, _)):
            return field.fieldId
        case .radio((let field, _)):
            return field.fieldId
        case .section((let field, _)):
            return field.fieldId
        case .number(( let field, _)):
            return field.fieldId
        }
    }
    
    var parentId: String? {
        switch self {
        case .textBox((let field, _)):
            return field.parentId
        case .radio((let field, _)):
            return field.parentId
        case .page((let field, _)):
            return field.parentId
        case .section((let field, _)):
            return field.parentId
        case .number(( let field, _)):
            return field.parentId
        }
    }
    
    var type: FieldType {
        switch self {
        case .textBox((let field, _)), .radio((let field, _)), .page((let field, _)), .section((let field, _)), .number((let field, _)):
            return field.type
        }
    }
    
}




