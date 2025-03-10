//
//  InputNumberView.swift
//  DFComponents
//
//  Created by Eslam on 09/03/2025.
//

import SwiftUI

struct InputNumberView: View {

    @ObservedObject var viewModel: NumberFieldViewModel
    @EnvironmentObject var formViewModel: FormViewModel
    @FocusState.Binding var isTextFieldFocused: Bool

    private var textBinding: Binding<String> {
        Binding(
            get: { viewModel.numberFieldModel.numberAnswer?.value ?? "" },
            set: { newValue in
                viewModel.baseAnswer?.value = newValue
                viewModel.characterCount = newValue.count
                viewModel.numberFieldModel.numberAnswer = viewModel.baseAnswer
                formViewModel.checkingWarning(for: viewModel.numberFieldModel.base.fieldId, value: newValue)
            }
        )
    }

    var body: some View {
        VStack {
            TextField(viewModel.numberFieldModel.placeHolder, text: textBinding)
                .padding(8)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.gray, lineWidth: 0.5)
                )
                .foregroundStyle(Color(red: 158 / 255, green: 179 / 255, blue: 194 / 255, opacity: 1))
                .keyboardType(.decimalPad)
                .focused($isTextFieldFocused)

        }
    }
}

