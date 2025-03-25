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

    func validate(fieldRender: any FieldRenderable,
                  value: Any?,
                  warnings: WarningsEntity?,
                  warningsMessagesDictionary: inout [String: [String]]) {
        guard var numberFieldRender = fieldRender as? NumberFieldRenderer else {
            return
        }

        let numberField = numberFieldRender.field
        let fieldId = numberField.fieldId ?? ""
        let numberViewModel = numberFieldRender.viewModel
        
        numberFieldRender.viewModel.baseAnswer?.value = (value as? String)

        var fieldWarnings: [String] = []

        guard let numberWarnings = numberViewModel.numberFieldModel.fieldWarning?.fieldValidation.input else {
            warningsMessagesDictionary[fieldId] = nil
            return
        }

        let numberValue = (numberViewModel.baseAnswer?.value as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Required field check
        if numberValue.isEmpty, numberViewModel.numberFieldModel.basePropertiesNotInteractive.required == true {
            requiredValidator.validate(
                fieldRender: fieldRender,
                value: numberValue,
                warnings: warnings,
                warningsMessagesDictionary: &warningsMessagesDictionary)
            return
        }

        // Numeric check
        if numberValue.rangeOfCharacter(from: CharacterSet.letters) != nil {
            fieldWarnings.append(numberWarnings.numeric)
        }

        // Decimal Places Validation
        if numberValue.contains("."),
           !validateDecimalPlaces(numberValue, maxDecimals: numberViewModel.numberFieldModel.decimalPlaces) {
            fieldWarnings.append(numberWarnings.custom.replacingOccurrences(of: "{0}", with: "\(numberViewModel.numberFieldModel.decimalPlaces ?? 0)"))
        }

        // Value Limits Validation
        let valueLimitValidator = ValueLimitValidationStrategy(
            minimumValue: numberViewModel.numberFieldModel.minimumValue ?? 0.0,
            maximumValue: numberViewModel.numberFieldModel.maximumValue ?? 0.0
        )
        valueLimitValidator.validate(value: numberValue, fieldWarnings: &fieldWarnings)

        // Entry Limits Validation
        let entryLimitValidator = EntryLimitValidationStrategy(
            minimumDigits: numberViewModel.numberFieldModel.minimumDigits ?? 0,
            maximumDigits: numberViewModel.numberFieldModel.maximumDigits ?? 0
        )
        entryLimitValidator.validate(value: numberValue, fieldWarnings: &fieldWarnings)

        // Store warnings in dictionary
        warningsMessagesDictionary[fieldId] = fieldWarnings.isEmpty ? nil : fieldWarnings

        DispatchQueue.main.async {
            numberViewModel.numberFieldModel.isError = !fieldWarnings.isEmpty
            let newErrorMessage = fieldWarnings.isEmpty ? nil : fieldWarnings.joined(separator: "\n")
            numberViewModel.numberFieldModel.errorMessage = newErrorMessage

            // Make sure to update the field's errorMessage as well to propagate the change
            numberFieldRender.errorMessage = newErrorMessage
        }

    }

    private func validateDecimalPlaces(_ value: String, maxDecimals: Int?) -> Bool {
        guard let maxDecimals = maxDecimals, let decimalPart = value.split(separator: ".").last else { return true }
        return decimalPart.count <= maxDecimals
    }
}
