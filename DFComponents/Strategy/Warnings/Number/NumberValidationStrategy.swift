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

        guard case .number(let numberField, let numberViewModel) = fieldEntity else { return }

        let fieldId = numberField.fieldId ?? ""
        var fieldWarning: String = ""

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
            fieldWarning = numberWarnings.numeric
        }

        // Decimal Places
        if numberValue.contains("."),
           !validateDecimalPlaces(numberValue, maxDecimals: numberViewModel.numberFieldModel.decimalPlaces) {
            fieldWarning = numberWarnings.custom.replacingOccurrences(of: "{0}", with: "\(numberViewModel.numberFieldModel.decimalPlaces ?? 0)")
        }

        /// Value Limits
        let valueLimitValidator = ValueLimitValidationStrategy(
            minimumValue: numberViewModel.numberFieldModel.minimumValue ?? 0.0,
            maximumValue: numberViewModel.numberFieldModel.maximumValue ?? 0.0
        )

        valueLimitValidator.validate(value: numberValue, fieldWarning: &fieldWarning)

        /// Entry Limits
        let entryLimitValidator = EntryLimitValidationStrategy(
            minimumDigits: numberViewModel.numberFieldModel.minimumDigits ?? 0,
            maximumDigits: numberViewModel.numberFieldModel.maximumDigits ?? 0)

        entryLimitValidator.validate(value: numberValue, fieldWarning: &fieldWarning)

        warningsMessagesDictionary[fieldId] = fieldWarning.isEmpty ? nil : [fieldWarning]

        DispatchQueue.main.async {
            numberViewModel.numberFieldModel.isError = !fieldWarning.isEmpty
            numberViewModel.numberFieldModel.errorMessage = fieldWarning.isEmpty ? nil : fieldWarning
        }

    }

    private func validateDecimalPlaces(_ value: String, maxDecimals: Int?) -> Bool {
        guard let maxDecimals = maxDecimals, let decimalPart = value.split(separator: ".").last else { return true }
        return decimalPart.count <= maxDecimals
    }
}
