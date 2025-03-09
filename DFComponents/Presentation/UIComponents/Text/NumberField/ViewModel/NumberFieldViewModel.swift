//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class NumberFieldViewModel: ObservableObject {
    @Published var numberFieldModel: NumberFieldModel
//    @Published var inputValue: String = ""
    @Published var characterCount: Int = 0
    var answer: BaseAnswerNumber?

    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        if numberFieldModel.numberProperties.defaultAnswer?.value != nil {
             answer = BaseAnswerNumber(value: numberFieldModel.numberProperties.defaultAnswer?.value ?? "")
//            self.inputValue = numberFieldModel.numberProperties.defaultAnswer?.value ?? ""
            self.characterCount = numberFieldModel.numberProperties.defaultAnswer?.value?.count ?? 0
        }
    }

    func incrementStepper() {
        guard let step = numberFieldModel.step,
              answer?.value?.rangeOfCharacter(from: .letters) == nil else { return }
        var incrementStep = Int(answer?.value ?? "") ?? 0
        incrementStep += step
        answer?.value = "\(incrementStep)"
        numberFieldModel.isError = incrementStep > 0 ? false : true
    }

    func decrementStepper() {
        guard let step = numberFieldModel.step,
              answer?.value?.rangeOfCharacter(from: .letters) == nil else { return }
        let decrementStep = Int(answer?.value ?? "") ?? 0
        let result = decrementStep - step
        answer?.value = "\(result)"
        numberFieldModel.isError = result >= 0 ? false : true
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = answer?.value?.split(separator: ".").count ?? 0 > 1
        ? answer?.value?.split(separator: ".")[1].count : 0
        return numberOfDecimals ?? 0 <= decimalPlaces
    }
}
