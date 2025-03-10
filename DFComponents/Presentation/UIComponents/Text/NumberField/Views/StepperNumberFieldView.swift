//
//  StepperNumberFieldView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct StepperNumberFieldView: View {
    @ObservedObject var viewModel: NumberFieldViewModel
    @EnvironmentObject var formViewModel:FormViewModel
    @FocusState.Binding var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            VStack(spacing: 3) {
                stepperButton(systemName: "chevron.up", action: "Increment")
                Rectangle()
                    .frame(width: 12, height: 1)
                    .foregroundStyle(.gray)
                stepperButton(systemName: "chevron.down", action: "Decrement")
            }
            .padding(8)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func stepperButton(systemName: String, action: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 12, height: 12)
            .foregroundStyle(.gray)
            .onTapGesture {
                viewModel.changeValueStepper(action: action)
                formViewModel.checkingWarning(for: viewModel.numberFieldModel.base.fieldId, value: viewModel.numberFieldModel.numberAnswer?.value ?? "")
                isTextFieldFocused = false
            }
    }
}
