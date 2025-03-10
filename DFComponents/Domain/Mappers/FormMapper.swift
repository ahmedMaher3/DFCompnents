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
    associatedtype Warnings
    func map (from dto: DTO) -> [FieldEntity]
    func map (from dto: Warnings) -> WarningsEntity

}

class FormMapper: EntityMapper {

    typealias DTO = Schema
    typealias Entity = FieldEntity
    typealias formWarnings = WarningsEntity

    func map(from dto: Schema) -> [FieldEntity] {
        return dto.fields.compactMap { field in
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


//struct Form {
//    var items: [FieldEntity]
//    var rules: [Rule]
//}

enum FieldEntity: Identifiable {
    case textBox((BaseFieldProtocol, TextBoxViewModel))
    case radio((BaseFieldProtocol, RadioButtonViewModel))
    case number((BaseFieldProtocol, NumberFieldViewModel))

    var id: String {
        switch self {
            case .textBox(( let field, _)):
                return field.fieldId
            case .radio(( let field, _)):
                return field.fieldId
            case .number(( let field, _)):
                return field.fieldId
        }
    }

    var answer: Any? {
        switch self {
            case .textBox(( let field, _)):
                return field.answer
            case .radio(( let field, _)):
                return field.answer
            case .number(( let field, _)):
                return field.answer
        }
    }
}




