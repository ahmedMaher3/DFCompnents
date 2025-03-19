//
//  NumberFieldModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

final class NumberField: InteractiveFieldDelegate {
    var base: InteractiveField
    var fieldWarning: WarningsEntity?
    let step: Int?
    let decimalPlaces: Int?
    let minimumDigits: Int?
    let maximumDigits: Int?
    let minimumValue: Double?
    let maximumValue: Double?

    init(field: Field?) {
        self.base = InteractiveField(field: field)
        if let properties = field?.properties as? NumberProperties {
            self.step = properties.step
            self.decimalPlaces = properties.decimalPlaces
            self.minimumDigits = properties.minimumDigits
            self.maximumDigits = properties.maximumDigits
            self.minimumValue = properties.minimumValue
            self.maximumValue = properties.maximumValue
            self.base.answer = properties.defaultAnswer
        } else {
            self.step = nil
            self.decimalPlaces = nil
            self.minimumDigits = nil
            self.maximumDigits = nil
            self.minimumValue = nil
            self.maximumValue = nil
            self.fieldWarning = nil
        }
    }
}
