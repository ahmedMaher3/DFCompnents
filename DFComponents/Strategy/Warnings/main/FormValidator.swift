//
//  FormValidator.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//
import Foundation
struct FormValidator {
    private let strategy: FieldValidationStrategy

    init(strategy: FieldValidationStrategy) {
        self.strategy = strategy
    }

    func validate(
        fieldRender: any FieldRenderable,
        value: Any?,
        warnings: WarningsEntity?,
        warningsMessagesDictionary: inout [String: [String]]) {
        strategy.validate(
            fieldRender: fieldRender,
            value: value,
            warnings: warnings,
            warningsMessagesDictionary: &warningsMessagesDictionary
        )
    }
}
