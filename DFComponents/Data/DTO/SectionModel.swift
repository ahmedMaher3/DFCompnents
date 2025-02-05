//
//  SectionModel.swift
//  DFComponents
//
//  Created by ahmed maher on 05/02/2025.
//

import Foundation
struct SectionModel: Identifiable {
    let id = UUID()
    let title: String
    var isExpanded: Bool
    let items: [String]
}
