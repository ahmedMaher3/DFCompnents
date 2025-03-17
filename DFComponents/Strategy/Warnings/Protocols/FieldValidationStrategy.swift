//
//  FieldValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//
import Foundation

protocol FieldValidationStrategy {
    func validate(
        fieldEntity: FieldEntity,
        value: Any?,
        warnings: WarningsEntity?,
        warningsMessagesDictionary: inout [String: [String]]
    )
}
