//
//  NumberFieldModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

class NumberFieldModel: NumberBaseDelegate {
    var numberBase: NumberBase
    var step: Int?
    var decimalPlaces: Int?
    var interactiveProperties: NumberBaseProperties?  // Store properties here

    init(field: Field?) {
        numberBase = NumberBase(field: field)
        if let properties = field?.properties as? NumberBaseProperties {
            step = properties.step
            decimalPlaces = properties.decimalPlaces
            interactiveProperties = properties
        } else {
            step = nil
            decimalPlaces = nil
            interactiveProperties = nil
        }
    }
}
