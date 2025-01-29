//
//  CheckBoxStyle.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    @Binding var selectedItems: Set<String>  // Track selected items by IDs

    let itemID: String  // Unique identifier for each checkbox item

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: selectedItems.contains(itemID) ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(selectedItems.contains(itemID) ? .primaryBlue : .primaryGray)
                .onTapGesture {
                    if selectedItems.contains(itemID) {
                        selectedItems.remove(itemID)
                    } else {
                        selectedItems.insert(itemID)
                    }
                }
                .padding(.trailing, 8)

            configuration.label
                .color(selectedItems.contains(itemID) ? .primaryBlue : .customColor(Color.black))
                .fontWeight(.medium)
        }
    }
}


