//
//  NumberFieldModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

class NumberFieldModel: NumberBaseDelegate {
    var numberProperties: NumberBase
    let step: Int?
    let decimalPlaces: Int?
    let minimumDigits: Int?
    let maximumDigits: Int?
    let minimumValue: Double?
    let maximumValue: Double?

    init(field: Field?) {
        self.numberProperties = NumberBase(field: field)
        if let properties = field?.properties as? NumberProperties {
            self.step = properties.step
            self.decimalPlaces = properties.decimalPlaces
            self.minimumDigits = properties.minimumDigits
            self.maximumDigits = properties.maximumDigits
            self.minimumValue = properties.minimumValue
            self.maximumValue = properties.maximumValue
        } else {
            self.step = nil
            self.decimalPlaces = nil
            self.minimumDigits = nil
            self.maximumDigits = nil
            self.minimumValue = nil
            self.maximumValue = nil
        }
    }

    /*
     var numberBaseInteractive: NumberBase
     var step: Int?
     var decimalPlaces: Int?
     var interactiveProperties: NumberComponentProperties?  // Store properties here

     init(field: Field?) {
     numberBase = NumberBase(field: field)
     if let properties = field?.properties as? NumberComponentProperties {
     step = properties.step
     decimalPlaces = properties.decimalPlaces
     interactiveProperties = properties
     } else {
     step = nil
     decimalPlaces = nil
     interactiveProperties = nil
     }
     }
     */

}
