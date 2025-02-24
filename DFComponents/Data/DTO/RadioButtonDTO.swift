//
//  RadioButtonDTO.swift
//  DFComponents
//
//  Created by Eslam on 30/01/2025.
//

import Foundation
class RadioButtonDTO: Identifiable {

    let id: String
    let name: String

    init(id: String, name: String) {

        self.id = id

        self.name = name

    }

    static var elementsRadioButton: [RadioButtonDTO] {
        return [

            RadioButtonDTO(id: "1", name: "Show"),

            RadioButtonDTO(id: "2", name: "Hide"),



        ]

    }

}

