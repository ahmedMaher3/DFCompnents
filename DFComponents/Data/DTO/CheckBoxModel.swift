//
//  CheckBoxModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

class CheckBoxModel: Identifiable, Hashable {

    let id: String
    let name: String
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static var elementsCheckBox: [CheckBoxModel] {
        return [
            CheckBoxModel(id: "1", name: "Red"),
            CheckBoxModel(id: "2", name: "Green"),
            CheckBoxModel(id: "3", name: "Blue"),
            CheckBoxModel(id: "4", name: "Yellow"),
            CheckBoxModel(id: "5", name: "Purple"),
            CheckBoxModel(id: "6", name: "Orange"),
            CheckBoxModel(id: "7", name: "Pink"),
            CheckBoxModel(id: "8", name: "Brown"),
            CheckBoxModel(id: "9", name: "Black"),
            CheckBoxModel(id: "10", name: "White")
        ]
    }

    static func == (lhs: CheckBoxModel, rhs: CheckBoxModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // You can combine multiple properties if needed
    }

}


