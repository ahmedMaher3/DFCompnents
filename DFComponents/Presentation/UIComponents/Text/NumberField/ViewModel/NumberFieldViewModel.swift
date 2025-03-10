//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//
import Foundation

final class NumberFieldViewModel: ObservableObject {
    
    @Published var numberFieldModel: NumberFieldModel
    @Published var characterCount: Int = 0
    
    var baseAnswer: BaseAnswerNumber? {
        get {
            return numberFieldModel.base.answer as? BaseAnswerNumber
        }
        set {
            numberFieldModel.base.answer = newValue
        }
    }
    
    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        if numberFieldModel.numberProperties.defaultAnswer?.value != nil {
            numberFieldModel.numberAnswer = BaseAnswerNumber(value: numberFieldModel.numberProperties.defaultAnswer?.value ?? "")
            self.numberFieldModel.base.answer = numberFieldModel.numberAnswer
            self.characterCount = numberFieldModel.numberProperties.defaultAnswer?.value?.count ?? 0
        }
    }

    func changeValueStepper(action type: String) {
        guard let step = numberFieldModel.step,
              numberFieldModel.numberAnswer?.value?.rangeOfCharacter(from: .letters) == nil else { return }
        var valueStep = Int(numberFieldModel.numberAnswer?.value ?? "") ?? 0
        valueStep = type == "Increment"
        ? valueStep + step
        : valueStep - step
        numberFieldModel.numberAnswer?.value = "\(valueStep)"
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = numberFieldModel.numberAnswer?.value?.split(separator: ".").count ?? 0 > 1
        ? numberFieldModel.numberAnswer?.value?.split(separator: ".")[1].count : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }
    
    func validateInput(value: String, warnings: WarningsEntity?) {
        guard let warnings = warnings else {
            DispatchQueue.main.async {
                self.numberFieldModel.isError = false
                self.numberFieldModel.errorMessage = nil
            }
            return
        }
        var fieldWarnings: [String] = []
        if value.rangeOfCharacter(from: CharacterSet.letters) != nil,
           let numericWarning = warnings.fieldValidation.input.numeric {
            fieldWarnings.append(numericWarning)
        }
        
        if value.contains("."),
           let customWarning = warnings.fieldValidation.input.custom,
           !validateDecimalPlaces() {
            fieldWarnings.append(customWarning.replacingOccurrences(of: "{0}", with: "invalid decimal places".localized))
        }
        
        if let inputNumber = Int(value) {
            if let minValue = Int(warnings.fieldValidation.number.minimumValue ?? ""),
               inputNumber < minValue {
                fieldWarnings.append("Minimum value allowed is \(minValue)")
            }
            if let maxValue = Int(warnings.fieldValidation.number.maximumValue ?? ""),
               inputNumber > maxValue {
                fieldWarnings.append("Maximum value allowed is \(maxValue)")
            }
        }
        
        if let maxDigits = numberFieldModel.maximumDigits,
           value.replacingOccurrences(of: ".", with: "").count > maxDigits {
            fieldWarnings.append("Maximum digits allowed is \(maxDigits)")
        }
        
        DispatchQueue.main.async {
            self.numberFieldModel.isError = !fieldWarnings.isEmpty
            self.numberFieldModel.errorMessage = fieldWarnings.isEmpty ? nil : fieldWarnings.joined(separator: "\n")
        }
    }
}
