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
        fieldWarnings: inout [String]) {
            guard let valueField = value else { return print("") }
            let inputValue = valueField.replacingOccurrences(of: ".", with: "")
            if let minimumDigits = minimumDigits,
               inputValue.count < minimumDigits && minimumDigits != 0 {
                fieldWarnings.append("Minimum digits required: \(minimumDigits)")
            }
            if let maximumDigits = maximumDigits,
               inputValue.count > maximumDigits && maximumDigits != 0 {
                fieldWarnings.append("Maximum digits allowed: \(maximumDigits)")
            }
        }
}
