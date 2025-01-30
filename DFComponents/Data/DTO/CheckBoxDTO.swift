//
//  CheckBoxDTO.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

class CheckBoxDTO: Identifiable, Hashable {

    let id: String
    let name: String
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static var elementsCheckBox: [CheckBoxDTO] {
        return [
            CheckBoxDTO(id: "1", name: "Red"),
            CheckBoxDTO(id: "2", name: "Green"),
            CheckBoxDTO(id: "3", name: "Blue"),
            CheckBoxDTO(id: "4", name: "Yellow"),
            CheckBoxDTO(id: "5", name: "Purple"),
            CheckBoxDTO(id: "6", name: "Orange"),
            CheckBoxDTO(id: "7", name: "Pink"),
            CheckBoxDTO(id: "8", name: "Brown"),
            CheckBoxDTO(id: "9", name: "Black"),
            CheckBoxDTO(id: "10", name: "White")
        ]
    }

    static func == (lhs: CheckBoxDTO, rhs: CheckBoxDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // You can combine multiple properties if needed
    }

}


