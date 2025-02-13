//
//  FormDTO.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import Foundation

struct FormDTO: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var fields: [String]
}
