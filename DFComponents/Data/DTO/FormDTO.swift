//
//  FormDTO.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import Foundation

struct FormDTO: Identifiable {
    let id: UUID = UUID()
    var name: String
    var fields: [String]
}
