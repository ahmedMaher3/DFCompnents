//
//  EntryLimitValidationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//

final class EntryLimitValidationStrategy: GeneralValidationStrategyProtocol {
    private let minimumDigits: Int?
    private let maximumDigits: Int?

    init(minimumDigits: Int?, maximumDigits: Int?) {
        self.minimumDigits = minimumDigits
        self.maximumDigits = maximumDigits
    }

    func validate(
        value: String?,
        fieldWarning: inout String) {
        guard let valueField = value else { return }
        let inputValue = valueField.replacingOccurrences(of: ".", with: "")
        if let minDigits = minimumDigits,
           inputValue.count < minDigits,
           minDigits != 0 {
            fieldWarning = "Minimum digits required: \(minDigits)"
        }

        if let maxDigits = maximumDigits,
           inputValue.count > maxDigits,
           maxDigits != 0 {
            fieldWarning = "Maximum digits allowed: \(maxDigits)"
        }
    }
}
