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
    
    static func == (lhs: CheckBoxDTO, rhs: CheckBoxDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // You can combine multiple properties if needed
    }

}


