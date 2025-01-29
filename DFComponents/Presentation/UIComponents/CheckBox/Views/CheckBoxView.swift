//
//  CheckBoxView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI


struct CheckBoxView: View {

    @ObservedObject var checkBoxState: CheckBoxViewModel
    let questionID: String
    let item: CheckBoxModel

    var body: some View {
        Toggle(isOn: Binding(
            get: { checkBoxState.selectedItems[questionID]?.contains(item.id) ?? false },
            set: { isSelected in
                checkBoxState.onTapCheckBox(questionID: questionID, item: item)
            }
        )) {
            HStack {
                Image(systemName: "checkmark.square.fill")
                    .color(.primaryGray)
                    .frame(width: 24, height: 24)
                Text(item.name)
            }
        }
    }
}
