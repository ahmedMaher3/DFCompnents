//
//  NumberValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

import Foundation

struct NumberValidationStrategy: FieldValidationStrategy {
    func validate(
        fieldId: String,
        value: Any?,
        warnings: WarningsEntity?,
        warningsDictionary: inout [String: [String]?],
        fields: [FieldEntity]) {
            guard let field = fields.first(where: { $0.id == fieldId }),
                  case .number((let baseField, let numberViewModel)) = field else {
                warningsDictionary[fieldId] = nil
                return
            }

            guard let numberWarnings = warnings?.fieldValidation else {
                warningsDictionary[fieldId] = nil
                return
            }

            let numberValue = (numberViewModel.baseAnswer?.value)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            var fieldWarnings: [String] = []

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

                if inputNumber < Double(minimumValue) {
                    fieldWarnings.append("Minimum value allowed is \(minimumValue)")
                }
                if  inputNumber > maximumValue {
                    fieldWarnings.append("Maximum value allowed is \(maximumValue)")
                }
            }

            // 🔹 Min/Max Digits Check (excluding decimal)
            let numericOnlyValue = numberValue.replacingOccurrences(of: ".", with: "")
            let minimumDigits = Int(numberViewModel.numberFieldModel.minimumDigits ?? 0)
            let maximumDigits = Int(numberViewModel.numberFieldModel.maximumDigits ?? 0)

            if numericOnlyValue.count < minimumDigits {
                fieldWarnings.append("Minimum digits required: \(numberViewModel.numberFieldModel.minimumDigits ?? 0)")
            }
            if numericOnlyValue.count > maximumDigits {
                fieldWarnings.append("Maximum digits allowed: \(numberViewModel.numberFieldModel.maximumDigits ?? 0)")
            }

            // 🔹 Update Warnings Dictionary
            warningsDictionary[baseField.fieldId] = fieldWarnings.isEmpty ? nil : fieldWarnings

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
