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
    @Published var currentValue: Int

    var baseProperties: BaseProperties?
    var interactiveProperties: NumberBase?

    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
        self.currentValue = numberFieldModel.decimalPlaces ?? 0
        self.baseProperties = BaseProperties(
            label: numberFieldModel.label,
            subLabel: numberFieldModel.sublabel,
            labelPosition: "", // Default or dynamic value
            tooltip: numberFieldModel.tooltip,
            hidden: numberFieldModel.hidden
        )
        if let properties = numberFieldModel.interactiveProperties {
            self.interactiveProperties = numberFieldModel.numberBase
        }
    }

    func incrementStepper() {
        guard let step = numberFieldModel.step else { return }
       currentValue += step
        objectWillChange.send()  // Notify SwiftUI to update the UI
        print("Incremented: \(currentValue)")
    }

    func decrementStepper() {
        guard let step = numberFieldModel.step else { return }
        let newValue = currentValue - step
        if newValue >= 0 { // Prevent going negative
           currentValue = newValue
            objectWillChange.send()  // Notify SwiftUI to update the UI
            print("Decremented: \(currentValue)")
        }
    }

}
