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
        ZStack {
            TextField(viewModel.numberFieldModel.placeHolder, text: $text)
                .padding(8)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused)
                .onChange(of: text) { _, newValue in
                    if let intValue = Int(newValue) {
                        viewModel.currentValue = intValue
                    }
                }
                .onChange(of: viewModel.currentValue) { _, newValue in
                    text = "\(newValue)"
                }
                .onAppear {
                    text = "\(viewModel.currentValue)"
                }
            /*
             TextField(viewModel.numberFieldModel.placeHolder, text: Binding(
             get: { "\(viewModel.currentValue)" },
             set: { newValue in
             if let intValue = Int(newValue) {
             viewModel.currentValue = intValue
             }
             }
             ))
             .padding(8)
             .frame(height: 45)
             .background(Color(.systemGray6))
             .cornerRadius(10)
             .keyboardType(.numberPad)
             .focused($isTextFieldFocused)

             .padding(.horizontal)
             */
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
