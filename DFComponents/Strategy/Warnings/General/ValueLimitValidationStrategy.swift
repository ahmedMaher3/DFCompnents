//
//  ValueLimitValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.

final class ValueLimitValidationStrategy: GeneralValidationStrategyProtocol {
    private let minimumValue: Double?
    private let maximumValue: Double?

    init(minimumValue: Double?, maximumValue: Double?) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    func validate(
        value: String?,
        fieldWarnings: inout [String]) {
        guard
            let valueField = value,
            let inputValue = Double(valueField) else { return }

        if let minimumValue = minimumValue,
           inputValue < minimumValue && minimumValue != 0 {
            fieldWarnings.append("Minimum value allowed is \(minimumValue)")
        }
            if let maximumValue = maximumValue,
            inputValue > maximumValue &&  maximumValue != 0 {
            fieldWarnings.append("Maximum value allowed is \(maximumValue)")
        }
    }
}
