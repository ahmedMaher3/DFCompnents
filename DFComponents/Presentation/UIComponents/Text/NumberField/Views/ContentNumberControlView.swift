//
//  ContentNumberControlView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct ContentNumberControlView: View {
    @ObservedObject var viewModel: NumberFieldViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var text: String = ""

    var body: some View {
        VStack {
            ZStack {
                TextField(viewModel.numberFieldModel.placeHolder, text: $text)
                    .padding(8)
                    .frame(height: 48)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.gray, lineWidth: 0.5)
                    )
                    .foregroundStyle(Color(red: 158 / 255, green: 179 / 255, blue: 194 / 255, opacity: 1))
                    .keyboardType(.decimalPad)
                    .focused($isTextFieldFocused)
                    .onChange(of: text) { oldValue, newValue in
                        viewModel.characterCount = newValue.count
                        if viewModel.inputValue != newValue {
                            if !newValue.isEmpty {
                                viewModel.inputValue = newValue
                            }
                        }
                    }

                /// Stepper
                if viewModel.numberFieldModel.step! != 0 {
                    StepperNumberFieldView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
                        .disabled(viewModel.numberFieldModel.isError ? true : false)
                } else {
                    EmptyView()
                }
            }
            .onReceive(viewModel.$inputValue) { newValue in
                if text != newValue {
                    text = newValue
                }
            }
            .onAppear {
                text = viewModel.inputValue
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(Rectangle()) // Ensures taps in empty areas are detected
        .onTapGesture {
            isTextFieldFocused = false // Close keyboard only when tapping outside
        }
    }
}
