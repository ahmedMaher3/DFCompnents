//
//  CheckBoxView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI


struct CheckBoxView: View {
    @ObservedObject var checkBoxVM: CheckBoxViewModel
    let questionID: String
    let item: CheckBoxDTO

    var body: some View {
        Toggle(isOn: Binding(
            get: { checkBoxVM.selectedItems[questionID]?.contains(item.id) ?? false },
            set: { isSelected in
                checkBoxVM.onTapCheckBox(questionID: questionID, item: item)
            }
        )) {
            Text(item.name)
        }
        .toggleStyle(CheckBoxStyle(questionID: questionID, item: item))
    }
}
