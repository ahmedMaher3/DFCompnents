//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//
import Foundation

final class NumberFieldViewModel: ObservableObject {
    @Published var numberFieldModel: NumberField
    @Published var characterCount: Int = 0
    @Published var warningsMessagesDictionary: [String: [String]] = [:]
    
    private var validator: FieldValidationStrategy {
        return FieldEntity.number(numberFieldModel, self).validatorField!
    }
    
    private var validateErrorMessage: ValidateFieldStrategy {
        return FieldEntity.number(numberFieldModel, self).validateViewModel!
    }
    
    var baseAnswer: BaseAnswerNumber? {
        get { return numberFieldModel.base.answer as? BaseAnswerNumber }
        set {
            numberFieldModel.base.answer = newValue
            numberFieldModel.numberAnswer = newValue
            guard let countDigit = numberFieldModel.numberAnswer?.value?.count else {
                return print("Value not valid")
            }
            characterCount = countDigit > 0 ? countDigit : 0
        }
    }
    
    var characterCountText: String {
        return calculateCharacterCountText()
    }
    
    init(numberFieldModel: NumberField) {
        self.numberFieldModel = numberFieldModel
        if let defaultValue = numberFieldModel.numberProperties.defaultAnswer?.value {
            baseAnswer = BaseAnswerNumber(value: defaultValue)
            self.numberFieldModel.base.answer = numberFieldModel.numberAnswer
            self.characterCount = defaultValue.count
        }
    }
    
    func changeValueStepper(action type: String) {
        guard let step = numberFieldModel.step,
              baseAnswer?.value?.rangeOfCharacter(from: .letters) == nil else { return }
        var valueStep = Int(baseAnswer?.value ?? "") ?? 0
        valueStep = type == "Increment"
        ? valueStep + step
        : valueStep - step
        baseAnswer?.value = "\(valueStep)"
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = baseAnswer?.value?.split(separator: ".").count ?? 0 > 1
        ? numberFieldModel.numberAnswer?.value?.split(separator: ".")[1].count : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }
    
    func validateInput(value: String, warnings: WarningsEntity?) {
        validator.validate(
            fieldEntity: .number(numberFieldModel, self),
            value: value,
            warnings: warnings,
            warningsMessagesDictionary: &warningsMessagesDictionary)

        let fieldId = numberFieldModel.fieldId ?? ""
        let numberWarnings = warningsMessagesDictionary[fieldId] ?? []
        Task { @MainActor in
            validateErrorMessage.updateValidationState(isError: self.numberFieldModel.isError, errorMessage: self.numberFieldModel.errorMessage)
            self.numberFieldModel.isError = !numberWarnings.isEmpty
            self.numberFieldModel.errorMessage = numberWarnings.joined(separator: "\n")
        }
    }
    
    private func calculateCharacterCountText() -> String {
        let currentCount = characterCount
        let minDigits = numberFieldModel.minimumDigits ?? 0
        let maxDigits = numberFieldModel.maximumDigits

        if let maxDigits = maxDigits, minDigits > 0 {
            if currentCount < minDigits {
                return "\(currentCount)/\(minDigits)"
            } else {
                return "\(currentCount)/\(maxDigits)"
            }
        }

        if minDigits > 0 {
            return "\(currentCount)/\(minDigits)"
        }

        if let maxDigits = maxDigits {
            return "\(currentCount)/\(maxDigits)"
        }

        return "\(currentCount)"
    }
}

