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
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .foregroundStyle(Color(red: 158 / 255, green: 179 / 255, blue: 194 / 255, opacity: 1))
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
