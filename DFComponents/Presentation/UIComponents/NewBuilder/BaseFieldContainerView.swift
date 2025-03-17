//
//  BaseFieldContainerView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct BaseFieldContainerView<Control: View>: View {
    let control: () -> Control
    let fieldEntity: FieldEntity
    @EnvironmentObject var viewModel: FormViewModel

    init(fieldEntity: FieldEntity,
        @ViewBuilder controlType: @escaping () -> Control) {
        self.control = controlType
        self.fieldEntity = fieldEntity
    }

    var body: some View {

        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
            BaseHeaderControlView(viewModel: BaseHeaderViewModel(fieldEntity: fieldEntity))

            /// Control with overlay for warnings
            control()
                .overlay(
                    viewModel.warningsMessagesDictionary?[fieldEntity.id]?.isEmpty == false ?
                    RoundedRectangle(cornerRadius: 4).stroke(.red, lineWidth: 0.5) : nil
                )

            /// Footer View - Aligned to Control
            BaseFooterControlView(viewModel: BaseFooterViewModel(control: fieldEntity))
                .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                .padding(.leading, 0) // Adjust leading padding as needed to match the control
            
            /// Warning View
            WarningCardView(message: viewModel.warningsMessagesDictionary?[fieldEntity.id]?.joined(separator: "") ?? "")
                .opacity(viewModel.warningsMessagesDictionary?[fieldEntity.id] == nil ? 0 : 1)
        }
        .padding(6)
        .background(viewModel.warningsMessagesDictionary?[fieldEntity.id] == nil ? Color.clear : Color.red.opacity(0.05))
        .cornerRadius(8)
    }
}

