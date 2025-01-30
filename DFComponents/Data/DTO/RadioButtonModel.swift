//
//  RadioButtonModel.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import Foundation
class RadioButtonModel: Identifiable {

    let id: String
    let name: String

    init(id: String, name: String) {

        self.id = id

        self.name = name

    }

    static var elementsRadioButton: [RadioButtonModel] {
        return [

            RadioButtonModel(id:  "1", name: "Red"),

            RadioButtonModel(id: "2", name: "Green"),

            RadioButtonModel(id: "3", name: "Blue"),

            RadioButtonModel(id: "4", name: "Yellow")

        ]

    }

}

