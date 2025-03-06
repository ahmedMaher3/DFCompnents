//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class NumberFieldViewModel: ObservableObject {
    //MARK: - NumberBaseProperties
    @Published var numberFieldModel: NumberFieldModel
    @Published var inputValue: String

    var baseProperties: BaseProperties?
    var interactiveProperties: NumberBase?

    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        self.inputValue = "\(numberFieldModel.decimalPlaces ?? 0)"
        self.baseProperties = BaseProperties(
            label: numberFieldModel.label,
            subLabel: numberFieldModel.sublabel,
            labelPosition: numberFieldModel.interactiveProperties?.labelPosition,
            tooltip: numberFieldModel.tooltip,
            hidden: numberFieldModel.hidden,
            required: numberFieldModel.required)
        self.interactiveProperties = numberFieldModel.numberBase
        if self.interactiveProperties?.decimalPlaces ?? 0 >= 0 {
            self.interactiveProperties?.isError = false
        }
    }

    func incrementStepper() {
        guard let step = numberFieldModel.step, inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        var incrementStep = Int(inputValue) ?? 0
        incrementStep += step
        inputValue = "\(incrementStep)"
        interactiveProperties?.isError = incrementStep > 0 ? false : true
    }

    func decrementStepper() {
        guard let step = numberFieldModel.step, inputValue.rangeOfCharacter(from: .letters) == nil else { return }
        let decrementStep = Int(inputValue) ?? 0
        let newValue = max(decrementStep - step, 0)
        inputValue = "\(newValue)"
        interactiveProperties?.isError = newValue >= 0 ? false : true
    }

}
