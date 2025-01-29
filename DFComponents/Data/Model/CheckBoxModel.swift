//
//  CheckBoxModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

class CheckBoxModel: Identifiable {
    let id: String
    let name: String
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static var elementsRadioButton: [CheckBoxModel] {
        return [
            CheckBoxModel(id: "1", name: "Red"),
            CheckBoxModel(id: "2", name: "Green"),
            CheckBoxModel(id: "3", name: "Blue"),
            CheckBoxModel(id: "4", name: "Yellow")
        ]
    }
}


