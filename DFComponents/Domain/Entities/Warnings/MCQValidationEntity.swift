//
//  MCQValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct MCQValidationEntity {
    let minimumNumberOfSelectedOptions: String
    let maximumNumberOfSelectedOptions: String
}
extension MCQValidationEntity {
    init(from dto: MCQValidation) {
        self.init(
            minimumNumberOfSelectedOptions: dto.minimumNumberOfSelectedOptions,
            maximumNumberOfSelectedOptions: dto.maximumNumberOfSelectedOptions
        )
    }
}
