//
//  ComponentType.swift
//  DFComponents
//
//  Created by hassan elshaer on 29/01/2025.
//

import Foundation

// MARK: - Component Types
enum ComponentType: Hashable {
    case textBox(config: TextBoxConfiguration)
    case dropDown(options: [String])
    case checkBox(isChecked: Bool)
    case dateTime(selectedDate: Date)
}
