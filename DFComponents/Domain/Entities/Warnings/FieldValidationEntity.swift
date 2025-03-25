//
//  FieldValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct FieldValidationEntity {
    let emptyForm, required, maxAttachment: String?
    let input: InputValidationEntity
    let number: NumberValidationEntity
    let dateTime: DateTimeValidationEntity
    let mcq: MCQValidationEntity
    let fileUpload: FileUploadValidationEntity
    let location: LocationValidationEntity
}

enum ValidationKey: String {
    case required, maxAttachment

    // Input Validations
    case minimumCharacterLength, maximumCharacterLength
    case minimumWordLength, maximumWordLength
    case email, url, numeric, alphabetic, alphanumeric, custom

    // Number Validations
    case minimumValue, maximumValue
    case minimumDigits, maximumDigits

    // DateTime Validations
    case dateTime, dateRange

    // MCQ Validations
    case minimumNumberOfSelectedOptions, maximumNumberOfSelectedOptions

    // File Upload Validations
    case maxFilesSize, maxSizePerFile
    case minNumberOfFiles, maxNumberOfFiles
    case allowedExtensions, invalidLink

    // Location Validations
    case maximumLocations, minimumLocations, notInRange
}
