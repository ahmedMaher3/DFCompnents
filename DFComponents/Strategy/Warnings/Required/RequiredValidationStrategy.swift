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
        warningsDictionary: inout [String: [String]]?) {
        let fieldId = fieldEntity.id

            guard let requiredWarning = warnings?.fieldValidation.required else {
                warningsDictionary?[fieldId] = nil
            return
        }

            let isEmpty = checkValueIsEmpty(value: value)
        let warningMessages: [String]? = isEmpty ? [requiredWarning] : nil

            warningsDictionary?[fieldId] = warningMessages

        if case .number((_, let numberViewModel)) = fieldEntity {
            let isError = warningMessages != nil
            let errorMessage = warningMessages?.joined(separator: "\n")

            DispatchQueue.main.async {
                numberViewModel.numberFieldModel.isError = isError
                numberViewModel.numberFieldModel.errorMessage = errorMessage
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
                return stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            default:
                return false
        }
    }
}
