//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//
import Foundation
/*
final class NumberFieldViewModel: ObservableObject,BaseViewModel {
    @Published var numberFieldModel: NumberField
    @Published var characterCount: Int = 0
    @Published var warningsMessagesDictionary: [String: [String]] = [:]
    private var validator: FieldValidationStrategy {
        return FieldEntity.number((numberFieldModel, self)).validatorField!
    }
    private var validateErrorMessage: ValidateFieldStrategy {
        return FieldEntity.number((numberFieldModel, self)).validateViewModel!
    }
    var baseAnswer: BaseAnswerNumber? {
        get { return numberFieldModel.base.answer as? BaseAnswerNumber }
        set {
            numberFieldModel.base.answer = newValue
            numberFieldModel.numberAnswer = newValue
            guard let countDigit = numberFieldModel.numberAnswer?.value?.count
            else { return print("Value not valid") }
            characterCount = countDigit > 0 ? countDigit : 0
        }
    }

    init(numberFieldModel: NumberField) {
        self.numberFieldModel = numberFieldModel
        if numberFieldModel.numberProperties.defaultAnswer?.value != nil {
            baseAnswer = BaseAnswerNumber(value: numberFieldModel.numberProperties.defaultAnswer?.value ?? "")
            self.numberFieldModel.base.answer = numberFieldModel.numberAnswer
            self.characterCount = numberFieldModel.numberProperties.defaultAnswer?.value?.count ?? 0
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
            fieldRender: ,
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
}
*/
/*
final class NumberFieldViewModel: ObservableObject, BaseViewModel {
    @Published var numberFieldModel: NumberField
    @Published var characterCount: Int = 0
    @Published var warningsMessagesDictionary: [String: [String]] = [:]

    private var validator: FieldValidationStrategy {
        return ((numberFieldModel as? (any FieldRenderable))?.validatorField)!
    }

    private var validateErrorMessage: ValidateFieldStrategy {
        return ((numberFieldModel as? (any FieldRenderable))?.validateViewModel)!
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

    init(numberFieldModel: NumberField) {
        self.numberFieldModel = numberFieldModel
        if let defaultAnswer = numberFieldModel.numberProperties.defaultAnswer?.value {
            baseAnswer = BaseAnswerNumber(value: defaultAnswer)
            self.numberFieldModel.base.answer = numberFieldModel.numberAnswer
            self.characterCount = defaultAnswer.count
        }
    }

    func changeValueStepper(action type: String) {
        guard let step = numberFieldModel.step,
              baseAnswer?.value?.rangeOfCharacter(from: .letters) == nil else { return }

        var valueStep = Int(baseAnswer?.value ?? "") ?? 0
        valueStep = type == "Increment" ? valueStep + step : valueStep - step
        baseAnswer?.value = "\(valueStep)"
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = baseAnswer?.value?.split(separator: ".").count ?? 0 > 1
            ? numberFieldModel.numberAnswer?.value?.split(separator: ".")[1].count
            : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }

    func validateInput(value: String, warnings: WarningsEntity?) {
        validator.validate(
            fieldRender: numberFieldModel, // <-- FIX: Pass `numberFieldModel` instead of `FieldEntity.number(...)`
            value: value,
            warnings: warnings,
            warningsMessagesDictionary: &warningsMessagesDictionary
        )

        let fieldId = numberFieldModel.fieldId ?? ""
        let numberWarnings = warningsMessagesDictionary[fieldId] ?? []

        Task { @MainActor in
            validateErrorMessage.updateValidationState(
                isError: !numberWarnings.isEmpty,
                errorMessage: numberWarnings.joined(separator: "\n")
            )
            self.numberFieldModel.isError = !numberWarnings.isEmpty
            self.numberFieldModel.errorMessage = numberWarnings.joined(separator: "\n")
        }
    }
}
*/
final class NumberFieldViewModel: ObservableObject, BaseViewModel {
    @Published var numberFieldModel: NumberField
    @Published var characterCount: Int = 0
    @Published var warningsMessagesDictionary: [String: [String]] = [:]

    private let validator: FieldValidationStrategy

    var baseAnswer: BaseAnswerNumber? {
        get { return numberFieldModel.base.answer as? BaseAnswerNumber }
        set {
            numberFieldModel.base.answer = newValue
            numberFieldModel.numberAnswer = newValue
            characterCount = newValue?.value?.count ?? 0
        }
    }

    init(numberFieldModel: NumberField) {
        self.numberFieldModel = numberFieldModel
        self.validator = NumberValidationStrategy()  // Use your validation strategy directly

        if let defaultAnswer = numberFieldModel.numberProperties.defaultAnswer?.value {
            baseAnswer = BaseAnswerNumber(value: defaultAnswer)
            self.numberFieldModel.base.answer = numberFieldModel.numberAnswer
            self.characterCount = defaultAnswer.count
        }
    }

    func changeValueStepper(action type: String) {
        guard let step = numberFieldModel.step,
              baseAnswer?.value?.rangeOfCharacter(from: .letters) == nil else { return }
        var valueStep = Int(baseAnswer?.value ?? "") ?? 0
        valueStep = type == "Increment" ? valueStep + step : valueStep - step
        baseAnswer?.value = "\(valueStep)"
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = baseAnswer?.value?.split(separator: ".").count ?? 0 > 1
            ? numberFieldModel.numberAnswer?.value?.split(separator: ".")[1].count
            : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }

    func validateInput(value: Double?, warnings: WarningsEntity?) {
        validator.validate(
            fieldRender: NumberFieldRenderer(field: numberFieldModel),
            value: value,
            warnings: warnings,
            warningsMessagesDictionary: &warningsMessagesDictionary
        )
        baseAnswer?.value = String(value ?? 0.0)
        let fieldId = numberFieldModel.fieldId ?? ""
        let numberWarnings = warningsMessagesDictionary[fieldId] ?? []

        Task { @MainActor in
            updateValidationState(isError: !numberWarnings.isEmpty, errorMessage: numberWarnings.joined(separator: "\n"))
            self.numberFieldModel.isError = !numberWarnings.isEmpty
            self.numberFieldModel.errorMessage = numberWarnings.joined(separator: "\n")
        }
    }
}

