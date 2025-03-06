//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class NumberFieldViewModel: ObservableObject {
    @Published var numberFieldModel: NumberFieldModel
    @Published var inputValue: String
    
    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        self.inputValue = numberFieldModel.numberProperties.defaultAnswer?.value ?? ""
    }
    
    func incrementStepper() {
        guard let step = numberFieldModel.step,
              inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        var incrementStep = Double(inputValue) ?? 0
        incrementStep += step
        inputValue = "\(incrementStep)"
        numberFieldModel.isError = incrementStep > 0 ? false : true
    }
    
    func decrementStepper() {
        guard let step = numberFieldModel.step,
              inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        let decrementStep = Double(inputValue) ?? 0
        let newValue = max(decrementStep - step, 0)
        inputValue = "\(newValue)"
        numberFieldModel.isError = newValue >= 0 ? false : true
    }
    //
    //    // validate decimal places
    //    func validateDecimalPlaces() -> Bool {
    //        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
    //        let numberOfDecimals = inputValue.split(separator: ".").count > 1
    //        ? inputValue.split(separator: ".")[1].count : 0
    //        numberFieldModel.isError = numberOfDecimals <= decimalPlaces ? false : true
    //        return numberOfDecimals <= decimalPlaces
    //    }
//    func validateDecimalPlaces() -> Bool {
//        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
//        guard !inputValue.isEmpty, inputValue.contains(".") else {
//            numberFieldModel.isError = false
//            return true
//        }
//        
//        let components = inputValue.split(separator: ".")
//        let numberOfDecimals = components.count > 1 ? components[1].count : 0
//        
//        let isValid = numberOfDecimals <= decimalPlaces
//        numberFieldModel.isError = !isValid
//        return isValid
//    }
    func validateDecimalPlaces() -> Bool {
        guard let decimalPlaces = numberFieldModel.decimalPlaces else { return true }
        let numberOfDecimals = inputValue.split(separator: ".").count > 1
            ? inputValue.split(separator: ".")[1].count : 0
        return numberOfDecimals <= decimalPlaces
    }

}
