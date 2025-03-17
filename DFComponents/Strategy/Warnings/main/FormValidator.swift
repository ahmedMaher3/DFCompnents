//
//  FormValidator.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//
import SwiftUI
struct FormValidator {
    private let strategy: FieldValidationStrategy

    init(strategy: FieldValidationStrategy) {
        self.strategy = strategy
    }

    func validate(
        fieldEntity: FieldEntity,
        value: Any?,
        warnings: WarningsEntity?,
        warningsMessagesDictionary: inout [String: [String]]) {
        strategy.validate(
            fieldEntity: fieldEntity,
            value: value,
            warnings: warnings,
            warningsMessagesDictionary: &warningsMessagesDictionary
        )
    }
}


