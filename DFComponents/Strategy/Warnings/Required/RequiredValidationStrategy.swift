//
//  RequiredValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//
import Foundation

struct RequiredValidationStrategy: FieldValidationStrategy {

    func validate(
        fieldEntity: FieldEntity,
        value: Any?,
        warnings: WarningsEntity?,
        warningsMessagesDictionary: inout [String: [String]]) {
        let fieldId = fieldEntity.id
        guard let requiredWarning = warnings?.fieldValidation.required else {
            warningsMessagesDictionary[fieldId] = nil
            return
        }
        let isEmpty = checkValueIsEmpty(value: value)
        let warningMessages: [String]? = isEmpty ? [requiredWarning] : nil
        let isError = warningMessages != nil
        let errorMessage = warningMessages?.joined(separator: "\n")
        warningsMessagesDictionary[fieldId] = warningMessages
            if let validateViewModel = fieldEntity.validateViewModel {
            Task { @MainActor in
                validateViewModel.updateValidationState(
                    isError: isError, errorMessage: errorMessage)
            }
        }
    }

    private func checkValueIsEmpty(value: Any?) -> Bool {
        switch value {
        case nil:
            return true
        case let collection as any Collection:
            return collection.isEmpty
        case let stringValue as String:
            return stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                .isEmpty
        default:
            return false
        }
    }
}
