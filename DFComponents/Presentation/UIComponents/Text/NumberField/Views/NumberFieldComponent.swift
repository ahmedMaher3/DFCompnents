//
//  NumberFieldComponent.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct NumberFieldComponent: View {
    @ObservedObject var viewModel: NumberFieldViewModel
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            ZStack {
                InputNumberView(viewModel: viewModel,
                                isTextFieldFocused: $isTextFieldFocused)
                /// Stepper
                if let step = viewModel.numberFieldModel.step, step != 0 {
                    StepperNumberFieldView(viewModel: viewModel,
                                           isTextFieldFocused: $isTextFieldFocused)
                } else {
                    EmptyView()
                }
            }
        }
    }
}
