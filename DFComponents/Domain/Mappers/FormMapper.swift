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
    func map(from dto: DTO) -> Entity
}

protocol OptionalEntityMapper {
    associatedtype DTO
    associatedtype Entity
    func map(from dto: DTO?) -> Entity?
}

class FormMapper: EntityMapper {
    
    typealias DTO = Schema

    func map(from dto: Schema) -> FormEntity {
        let pages = mapToPages(fields: dto.fields,
                               mode: dto.settings.format, schemaProperties: dto.properties)
        let header: PageHeaderEntity? = PageHeaderMapper().map(from: dto.campaign?.header)
        let footer: PageFooterEntity? = PageFooterMapper().map(from: dto.campaign?.footer)
        let welcomeEntity: WelcomeEntity? = WelcomeEntity(cardWelcomeData: dto.campaign?.welcome, questionCount: pages.count)
        let warnings = mapWarnings(from: dto.warnings)
        let rules =  dto.rules
        return FormEntity(
            pages: pages,
            rules: rules ?? [],
            warnings: warnings,
            header: header,
            footer: footer,
            welcome: welcomeEntity
        )
    }

    private func mapToPages(fields: [Field], mode: FormType, schemaProperties: SchemaProperties) -> [PageEntity] {

        return mode == .classic ? mapToPagesInClassicMode(fields: fields, mode: mode) : mapToPagesInCardsMode(fields: fields, mode: mode, schemaProperties: schemaProperties)
    }

    func mapToPagesInClassicMode(fields: [Field], mode: FormType) -> [PageEntity] {
        let pagesData = fields.filter { $0.type == .page } // Extract page fields
        let groupedFields = Dictionary(grouping: fields.filter { $0.parentId != nil }) { $0.parentId! }
        let pages = pagesData.compactMap { page -> PageEntity? in
            guard let pageId = page.id else { return nil }
            let mappedFields = mapFieldsRecursively(fields: groupedFields[pageId] ?? [], groupedFields: groupedFields)
            return PageEntity(
                id: pageId,
                fields: mappedFields,
                mode: mode,
                page: PageField(field: page)
            )
        }
        return pages
    }

    private func mapToPagesInCardsMode(fields: [Field], mode: FormType, schemaProperties: SchemaProperties) -> [PageEntity] {
        var pages: [PageEntity] = []
        var cardIndex = 1
        let cardFields = fields.filter { $0.type != .page && $0.type != .section }
        for field in cardFields {
            let pageId = "page_\(cardIndex)"
            let mappedFields = mapFieldsRecursively(fields: [field], groupedFields: [:]) // Map single field
            
            let page = PageField(field: field, schemaProperties: schemaProperties)

            let PageEntity = PageEntity(
                id: pageId,
                fields: mappedFields,
                mode: mode,
                page: page
            )
            pages.append(PageEntity)
            cardIndex += 1
        }

        return pages
    }

    private func mapFieldsRecursively(fields: [Field], groupedFields: [String: [Field]]) -> [FieldEntity] {
        return fields.compactMap { field in
            if field.type == .section {
                let sectionControls = mapFieldsRecursively(fields: groupedFields[field.id!] ?? [], groupedFields: groupedFields)
                let control = SectionField(field: field)
                return .section(control, SectionViewModel(controls: sectionControls, sectionField: control))

            }
            return mapSingleField(field: field)
        }
    }

    private func mapSingleField(field: Field) -> FieldEntity? {
        switch field.type {
            case .textBox:
                let control = TextBoxField(field: field)
            return .textBox(control, TextBoxViewModel(control: control))
            case .radio:
                let control = RadioButtonField(field: field)
            return .radio(control, RadioButtonViewModel(control: control))
            case .number:
                let control = NumberField(field: field)
            return .number(control, NumberFieldViewModel(numberFieldModel: control))
            default:
                return nil
        }
    }

    func mapWarnings(from dto: Warnings) -> WarningsEntity {
        return WarningsEntity(
            formValidation: mapFormValidation(from: dto.formWarning.formValidation),
            fieldValidation: mapFieldValidation(from: dto.formWarning.fieldValidation)
        )
    }

    private func mapFormValidation(from dto: FormValidation) -> FormValidationEntity {
        return FormValidationEntity(
            expired: dto.expired,
            notAvailable: dto.notAvailable,
            multipleSubmission: dto.multipleSubmission,
            notStarted: dto.notStarted
        )
    }

    private func mapFieldValidation(from dto: FieldValidation) -> FieldValidationEntity {
        return FieldValidationEntity(
            emptyForm: dto.emptyForm,
            required: dto.required,
            maxAttachment: dto.maxAttachment,
            input: mapValidation(from: dto.input, using: InputValidationEntity.init),
            number: mapValidation(from: dto.number, using: NumberValidationEntity.init),
            dateTime: mapValidation(from: dto.dateTime, using: DateTimeValidationEntity.init),
            mcq: mapValidation(from: dto.mcq, using: MCQValidationEntity.init),
            fileUpload: mapValidation(from: dto.fileUpload, using: FileUploadValidationEntity.init),
            location: mapValidation(from: dto.location, using: LocationValidationEntity.init)
        )
    }

    private func mapValidation<DTO, Entity>(from dto: DTO, using transform: (DTO) -> Entity) -> Entity {
        return transform(dto)
    }
}








