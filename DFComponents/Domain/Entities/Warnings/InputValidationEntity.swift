//
//  InputValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct InputValidationEntity {
    let minimumCharacterLength: String
    let maximumCharacterLength: String
    let minimumWordLength: String
    let maximumWordLength: String
    let email: String
    let url: String
    let numeric: String
    let alphabetic: String
    let alphanumeric: String
    let custom: String
}
extension InputValidationEntity {
    init(from dto: InputValidation) {
        self.init(
            minimumCharacterLength: dto.minimumCharacterLength,
            maximumCharacterLength: dto.maximumCharacterLength,
            minimumWordLength: dto.minimumWordLength,
            maximumWordLength: dto.maximumWordLength,
            email: dto.email,
            url: dto.url,
            numeric: dto.numeric,
            alphabetic: dto.alphabetic,
            alphanumeric: dto.alphanumeric,
            custom: dto.custom
        )
    }
}
