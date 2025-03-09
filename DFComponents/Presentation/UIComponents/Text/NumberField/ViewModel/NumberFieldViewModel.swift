//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class NumberFieldViewModel: ObservableObject {
    @Published var numberFieldModel: NumberFieldModel
    @Published var inputValue: String = ""
    @Published var characterCount: Int = 0

    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        if numberFieldModel.numberProperties.defaultAnswer?.value != nil {
            let answer = BaseAnswerNumber(value: numberFieldModel.numberProperties.defaultAnswer?.value ?? "")
            print("Display the answer please:\(answer)")
            self.inputValue = numberFieldModel.numberProperties.defaultAnswer?.value ?? ""
            self.characterCount = numberFieldModel.numberProperties.defaultAnswer?.value?.count ?? 0
        }
    }

    func incrementStepper() {
        guard let step = numberFieldModel.step,
              inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        var incrementStep = Int(inputValue) ?? 0
        incrementStep += step
        inputValue = "\(incrementStep)"
        numberFieldModel.isError = incrementStep > 0 ? false : true
    }

    func decrementStepper() {
        guard let step = numberFieldModel.step,
              inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        let decrementStep = Int(inputValue) ?? 0
        let result = decrementStep - step
        inputValue = "\(result)"
        numberFieldModel.isError = result >= 0 ? false : true
    }

    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = inputValue.split(separator: ".").count > 1
        ? inputValue.split(separator: ".")[1].count : 0
        return numberOfDecimals <= decimalPlaces
    }


}
