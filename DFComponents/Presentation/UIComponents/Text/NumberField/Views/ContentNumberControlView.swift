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
                TextField(viewModel.numberFieldModel.placeHolder, text: $text.onChange(numberChanged))
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

                /// Stepper
                if let step = viewModel.numberFieldModel.step, step != 0 {
                    StepperNumberFieldView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
                        .disabled(viewModel.numberFieldModel.isError ? true : false)
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                text = viewModel.answer?.value ?? ""
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        let answer = BaseAnswerNumber(value: text)
                        viewModel.numberFieldModel.answer = answer
                        print("Display please the input value from user:\(text) and answer please become:\(viewModel.numberFieldModel.answer)")
                        isTextFieldFocused = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }

    func numberChanged(to value: String) {
        viewModel.characterCount = value.count
        //viewModel.answer?.value != value && !value.isEmpty
        if viewModel.answer?.value != value {
            viewModel.answer?.value = value
        }
    }
}

