//
//  NumberBase.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.

protocol NumberBaseDelegate: InteractiveFieldDelegate {
    var numberProperties: NumberBase { get set }
}

class NumberBase: InteractiveFieldDelegate {
    var base: InteractiveField
    var baseProperties: BaseProperties?

    let step: Int?
    let decimalPlaces: Int?
    let minimumDigits: Int?
    let maximumDigits: Int?
    let minimumValue: Double?
    let maximumValue: Double?
    let defaultAnswer: BaseAnswerNumber?

    init(field: Field?) {
        self.base = InteractiveField(field: field)

        if let properties = field?.properties as? NumberProperties {
            step = properties.step
            decimalPlaces = properties.decimalPlaces
            minimumValue = properties.minimumValue
            maximumValue = properties.maximumValue
            minimumDigits = properties.minimumDigits
            maximumDigits = properties.maximumDigits
            defaultAnswer = properties.defaultAnswer

            self.baseProperties = BaseProperties(
                label: properties.label,
                subLabel: properties.subLabel,
                tooltip: properties.tooltip,
                hidden: properties.hidden,
                required: properties.required)
        } else {
            step = nil
            decimalPlaces = nil
            minimumValue = nil
            maximumValue = nil
            minimumDigits = nil
            maximumDigits = nil
            defaultAnswer = nil
        }
    }
}

extension NumberBaseDelegate {
    var base: InteractiveField {
        get { numberProperties.base }
        set { numberProperties.base = newValue }
    }
    var basePropertiesNotInteractive: BaseProperties {
        get { numberProperties.baseProperties! }
    }
}
