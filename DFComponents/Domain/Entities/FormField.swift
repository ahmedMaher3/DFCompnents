//
//  FormField.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/18/25.
//

import Foundation

struct FormField: Identifiable {
    let id: String
    let type: FieldType
    let label: String
    let sublabel: String?
    var value: String?
    let isRequired: Bool
    let properties: FieldProperties?
    var isVisible: Bool
    let rules: FieldRules?
    var field: Field  // Add the `field` property, which holds the actual Field

    init(field: Field) {
        id = field.id ?? ""
        type = field.type
        label = field.properties.label
        sublabel = field.properties.sublabel
        value = ""
        isRequired = field.properties.required ?? false
        properties = field.properties
        isVisible = true
        rules = field.rules
        self.field = field
    }
}
