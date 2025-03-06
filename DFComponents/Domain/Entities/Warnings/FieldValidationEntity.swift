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
