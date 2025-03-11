//
//  NumberValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

import Foundation

final class NumberValidationStrategy: FieldValidationStrategy {
    private let requiredValidator = ValidatorContext(strategy: RequiredValidationStrategy())

    func validate(
        fieldEntity: FieldEntity,
        value: Any?,
        warnings: WarningsEntity?,
        warningsDictionary: inout [String: [String]?]
    ) {
        guard case .number((let numberField, let numberViewModel)) = fieldEntity else {
            return
        }

        let fieldId = numberField.fieldId ?? ""
        var fieldWarnings: [String] = []

        // Extract warnings configuration
        guard let numberWarnings = warnings?.fieldValidation else {
            warningsDictionary[fieldId] = nil
            return
        }

        // Ensure value is a trimmed string
        let numberValue = numberViewModel.baseAnswer?.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if numberValue.isEmpty && numberViewModel.numberFieldModel.basePropertiesNotInteractive.required == true {

            requiredValidator.validate(
                fieldEntity: fieldEntity,
                value: numberValue,  // ✅ Pass the correct value
                warnings: warnings,
                warningsDictionary: &warningsDictionary
            )
            return
        }

        // 🔹 Prevent non-numeric characters
        if numberValue.rangeOfCharacter(from: CharacterSet.letters) != nil {
            fieldWarnings.append(numberWarnings.input.numeric)
        }

        // 🔹 Decimal places validation
        if numberValue.contains("."),
           !validateDecimalPlaces(numberValue, maxDecimals: numberViewModel.numberFieldModel.decimalPlaces) {
            fieldWarnings.append(numberWarnings.input.custom.replacingOccurrences(of: "{0}", with: "Invalid decimal places"))
        }

        // 🔹 Min/Max Value Check
        if let inputNumber = Double(numberValue) {
            let minimumValue = Double(numberViewModel.numberFieldModel.minimumValue ?? 0.0)
            let maximumValue = Double(numberViewModel.numberFieldModel.maximumValue ?? 0.0)

            if inputNumber < minimumValue {
                fieldWarnings.append("Minimum value allowed is \(minimumValue)")
            }
            if inputNumber > maximumValue {
                fieldWarnings.append("Maximum value allowed is \(maximumValue)")
            }
        }

        // 🔹 Min/Max Digits Check (excluding decimal)
        let numericOnlyValue = numberValue.replacingOccurrences(of: ".", with: "")
        let minimumDigits = Int(numberViewModel.numberFieldModel.minimumDigits ?? 0)
        let maximumDigits = Int(numberViewModel.numberFieldModel.maximumDigits ?? 0)

        if numericOnlyValue.count < minimumDigits {
            fieldWarnings.append("Minimum digits required: \(minimumDigits)")
        }
        if numericOnlyValue.count > maximumDigits {
            fieldWarnings.append("Maximum digits allowed: \(maximumDigits)")
        }

        // 🔹 Store warnings in dictionary
        warningsDictionary[fieldId] = fieldWarnings.isEmpty ? nil : fieldWarnings

        // 🔹 UI Updates
        DispatchQueue.main.async {
            numberViewModel.numberFieldModel.isError = !fieldWarnings.isEmpty
            numberViewModel.numberFieldModel.errorMessage = fieldWarnings.isEmpty ? nil : fieldWarnings.joined(separator: "\n")
        }
    }

    // ✅ Validate decimal places
    private func validateDecimalPlaces(_ value: String, maxDecimals: Int?) -> Bool {
        guard let maxDecimals = maxDecimals, let decimalPart = value.split(separator: ".").last else { return true }
        return decimalPart.count <= maxDecimals
    }
}
