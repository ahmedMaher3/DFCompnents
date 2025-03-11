//
//  ContextValidator.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

import Foundation
struct ValidatorContext {
    private let strategy: FieldValidationStrategy

    init(strategy: FieldValidationStrategy) {
        self.strategy = strategy
    }

    func validate(
        fieldId: String,
        value: Any?,
        warnings: WarningsEntity?,
        warningsDictionary: inout [String: [String]?],
        fields: [FieldEntity]) {
        strategy.validate(
            fieldId: fieldId,
            value: value,
            warnings: warnings,
            warningsDictionary: &warningsDictionary,
            fields: fields
        )
    }
}
