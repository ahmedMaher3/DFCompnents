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

    private let validator: FieldValidationStrategy

//    private lazy var fieldRender: NumberFieldRenderer = {
//        return NumberFieldRenderer(field: numberFieldModel)
//    }()


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
        print("Show error message:\(numberFieldModel.errorMessage)")
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = baseAnswer?.value?.split(separator: ".").count ?? 0 > 1
            ? numberFieldModel.numberAnswer?.value?.split(separator: ".")[1].count
            : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }

    func validateInput(value: String?, warnings: WarningsEntity?) {
//        validator.validate(
//            fieldRender: fieldRender,
//            value: value,
//            warnings: warnings,
//            warningsMessagesDictionary: &warningsMessagesDictionary
//        )
        let fieldId = numberFieldModel.fieldId ?? ""
        let numberWarnings = warningsMessagesDictionary[fieldId] ?? []

        Task { @MainActor in
            updateValidationState(isError: !numberWarnings.isEmpty, errorMessage: numberWarnings.joined(separator: "\n"))
            self.numberFieldModel.isError = !numberWarnings.isEmpty
            self.numberFieldModel.errorMessage = numberWarnings.joined(separator: "\n")
        }
    }
}
