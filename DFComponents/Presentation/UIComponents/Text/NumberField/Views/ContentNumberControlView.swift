//
//  ContentNumberControlView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI

struct ContentNumberControlView: View {
    
    @ObservedObject var viewModel: NumberFieldViewModel
    @EnvironmentObject var formViewModel:FormViewModel
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            ZStack {
                InputNumberView(viewModel: viewModel, isTextFieldFocused: $isTextFieldFocused)
                /// Stepper
                if let step = viewModel.numberFieldModel.step, step != 0 {
                    StepperNumberFieldView(viewModel: viewModel,
                                           isTextFieldFocused: $isTextFieldFocused)
                        .disabled(viewModel.numberFieldModel.isError ? true : false)
                } else {
                    EmptyView()
                }
            }
        }
    }
}
