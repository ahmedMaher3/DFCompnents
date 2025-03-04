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
                .padding(.leading, 10)
                .frame(height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .focused($isTextFieldFocused) // Attach focus state
                .onChange(of: viewModel.numberFieldModel.step) { _, newValue in
                    text = "\(newValue ?? 0)"
                }
                .padding(.horizontal)
            /// Stepper
            if viewModel.numberFieldModel.step! != 0 {
                StepperNumberFieldView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
                    .allowsHitTesting(true)
            } else {
                EmptyView()
            }
        }
    }
}

//#Preview {
//    ContentNumberControlView()
//}
