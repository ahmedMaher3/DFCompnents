//
//  ContentNumberControlView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct ContentNumberControlView: View {
    @StateObject var viewModel: NumberFieldViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var text: String = ""

    var body: some View {
        ZStack {
            TextField(viewModel.numberFieldModel.placeHolder, text: $text)
                .padding(8)
                .frame(height: 48)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(viewModel.interactiveProperties?.isError ?? false
                                ? .red : .gray, lineWidth: 0.5)
                )
                .foregroundStyle(Color(red: 158 / 255, green: 179 / 255, blue: 194 / 255, opacity: 1))
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused)
                .onChange(of: text) { _, newValue in
                    if newValue.allSatisfy({ $0.isNumber }) {
                        viewModel.numberFieldModel.isError = false
                    } else if newValue.rangeOfCharacter(from: .letters) != nil {
                        viewModel.numberFieldModel.isError = true
                    } else {
                        viewModel.numberFieldModel.isError = false
                    }
                    viewModel.inputValue = newValue
                }
                .onChange(of: viewModel.inputValue) { _, newValue in
                    text = "\(newValue)"
                }
                .onAppear {
                    text = "\(viewModel.inputValue)"
                }
            /// Stepper
            if viewModel.numberFieldModel.step! != 0 {
                StepperNumberFieldView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    ContentNumberControlView()
//}
