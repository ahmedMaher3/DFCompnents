//
//  NumberBase.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.

protocol NumberBaseDelegate: InteractiveFieldDelegate {
    var numberBase: NumberBase { get set }
}

class NumberBase: InteractiveFieldDelegate {
    var base: InteractiveField
    let step: Int?
    let decimalPlaces: Int?

    init(field: Field?) {
        self.base = InteractiveField(field: field)
        if let properties = field?.properties as? NumberBaseProperties {
            step = properties.step
            decimalPlaces = properties.decimalPlaces
        } else {
            step = nil
            decimalPlaces = nil
        }
    }
}

extension NumberBaseDelegate {
    var base: InteractiveField {
        get { numberBase.base }
        set { numberBase.base = newValue }
    }
}
