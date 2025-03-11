//
//  RequiredValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

import Foundation
struct RequiredValidationStrategy: FieldValidationStrategy {
    func validate(
        fieldId: String,
        value: Any?,
        warnings: WarningsEntity?,
        warningsDictionary: inout [String: [String]?],
        fields: [FieldEntity]
    ) {
        guard let field = fields.first(where: { $0.id == fieldId }) else {
            warningsDictionary[fieldId] = nil
            return
        }

        // 🔹 Extract required warning message
        guard let requiredWarning = warnings?.fieldValidation.required else {
            warningsDictionary[fieldId] = nil
            return
        }

        // 🔹 Check if the value is empty
        let isEmpty = checkValueIsEmpty(value: value)
        let warningMessages: [String]? = isEmpty ? [requiredWarning] : nil

        // 🔹 Store warnings **before** calling DispatchQueue.main.async
        warningsDictionary[fieldId] = warningMessages

        // 🔹 UI Updates for Number Fields
        if case .number((_, let numberViewModel)) = field {
            let isError = warningMessages != nil
            let errorMessage = warningMessages?.joined(separator: "\n")

            DispatchQueue.main.async {
                numberViewModel.numberFieldModel.isError = isError
                numberViewModel.numberFieldModel.errorMessage = errorMessage
            }
        }
    }

    /// 🔍 Check if the provided value is empty
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
