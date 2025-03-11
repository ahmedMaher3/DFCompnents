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
    @Binding var warningMessage: String?

    init(
        fieldEntity: FieldEntity,
        @ViewBuilder controlType: @escaping () -> Control,
        warningMessage: Binding<String?>
    ) {
        self.control = controlType
        self.fieldEntity = fieldEntity
        self._warningMessage = warningMessage
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            /// Header View
            BaseHeaderControlView(viewModel: BaseHeaderViewModel(fieldEntity: fieldEntity))

            /// Control with overlay for warnings
            control()
                .overlay(
                    warningMessage?.isEmpty == false ?
                    RoundedRectangle(cornerRadius: 4).stroke(.red, lineWidth: 0.5) : nil
                )

            /// Footer View - Aligned to Control
            BaseFooterControlView(viewModel: BaseFooterViewModel(control: fieldEntity))
                .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                .padding(.leading, 0) // Adjust leading padding as needed to match the control
            
            /// Warning View
            if let warning = warningMessage, !warning.isEmpty {
                WarningCardView(message: warning)
                    .padding(6)
                    .background(Color.red.opacity(0.05))
                    .cornerRadius(8)
            }
        }
    }
}

