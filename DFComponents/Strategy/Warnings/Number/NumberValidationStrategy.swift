//
//  NumberValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

import Foundation

final class NumberValidationStrategy: FieldValidationStrategy {
    private let requiredValidator: FormValidator

    init() {
        requiredValidator = FormValidator(strategy: RequiredValidationStrategy())
    }

    func validate(fieldEntity: FieldEntity,
                  value: Any?,
                  warnings: WarningsEntity?,
                  warningsMessagesDictionary: inout [String: [String]]) {

        guard case .number((let numberField, let numberViewModel)) = fieldEntity else { return }

        let fieldId = numberField.fieldId ?? ""
        var fieldWarnings: [String] = []

        guard let numberWarnings = numberViewModel.numberFieldModel.fieldWarning?.fieldValidation.input else {
            warningsMessagesDictionary[fieldId] = nil
            return
        }

        let numberValue = numberViewModel.baseAnswer?.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if numberValue.isEmpty && numberViewModel.numberFieldModel.basePropertiesNotInteractive.required == true {
            requiredValidator.validate(
                fieldEntity: fieldEntity,
                value: numberValue,
                warnings: warnings,
                warningsMessagesDictionary: &warningsMessagesDictionary)
            return
        }

        // Numeric check
        if numberValue.rangeOfCharacter(from: CharacterSet.letters) != nil {
            fieldWarnings.append(numberWarnings.numeric)
        }

        // Decimal Places
        if numberValue.contains("."),
           !validateDecimalPlaces(numberValue, maxDecimals: numberViewModel.numberFieldModel.decimalPlaces) {
            fieldWarnings.append(numberWarnings.custom.replacingOccurrences(of: "{0}", with: "\(numberViewModel.numberFieldModel.decimalPlaces ?? 0)"))
        }

        /// Value Limits
        let valueLimitValidator = ValueLimitValidationStrategy(
            minimumValue: numberViewModel.numberFieldModel.minimumValue ?? 0.0,
            maximumValue: numberViewModel.numberFieldModel.maximumValue ?? 0.0
        )

        valueLimitValidator.validate(value: numberValue, fieldWarnings: &fieldWarnings)

        /// Entry Limits
        let entryLimitValidator = EntryLimitValidationStrategy(
            minimumDigits: numberViewModel.numberFieldModel.minimumDigits ?? 0,
            maximumDigits: numberViewModel.numberFieldModel.maximumDigits ?? 0)

        entryLimitValidator.validate(value: numberValue, fieldWarnings: &fieldWarnings)

        warningsMessagesDictionary[fieldId] = fieldWarnings.isEmpty ? nil : fieldWarnings

        Task { @MainActor in
            numberViewModel.numberFieldModel.isError = !fieldWarnings.isEmpty
            numberViewModel.numberFieldModel.errorMessage = fieldWarnings.isEmpty ? nil : fieldWarnings.joined(separator: "\n")
        }
    }

    private func validateDecimalPlaces(_ value: String, maxDecimals: Int?) -> Bool {
        guard let maxDecimals = maxDecimals, let decimalPart = value.split(separator: ".").last else { return true }
        return decimalPart.count <= maxDecimals
    }
}
