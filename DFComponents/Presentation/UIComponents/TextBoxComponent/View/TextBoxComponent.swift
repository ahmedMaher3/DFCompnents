//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

// MARK: - TextBoxComponent
struct TextBoxComponent: View {
    @ObservedObject var viewModel: TextBoxViewModel
    @EnvironmentObject var styleManagerVM: StyleManagerViewModel
    var isDisabled: Bool = false // Add this line


    var body: some View {
        let styleManager = styleManagerVM.styleManager
        
        if viewModel.control.hidden {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: styleManager.innerPadding) {
                // Title and Subtitle
                VStack(alignment: .leading, spacing: 2) {

                }
               // .padding(.bottom, styleManager.innerPadding)
                let borderColor = viewModel.hasInteracted ? (viewModel.isValid ? styleManager.borderValidColor : styleManager.errorColor) : styleManager.borderColor
                // Input Field with Prefix and Suffix
                HStack {
                    // Prefix
                    if !viewModel.prefixOptions.isEmpty {
                        CustomDropdownView(
                            selectedOption: $viewModel.selectedPrefix,
                            options: viewModel.prefixOptions,
                            label: "Prefix",
                            borderColor: borderColor
                        )
                        .disabled(isDisabled) // Use isDisabled here
                        .opacity(isDisabled ? 0.6 : 1.0)
                    }

                    TextField(viewModel.placeholder, text: $viewModel.text, onEditingChanged: { isEditing in
                        if !isDisabled {
                            viewModel.onEditingChanged(isEditing: isEditing)
                        }
                    })
                    .padding()
                    .frame(height: 48)
                    .styledBorder(color: borderColor, width: styleManager.borderWidth, cornerRadius: styleManager.cornerRadius)
                    .background(
                        RoundedRectangle(cornerRadius: styleManager.cornerRadius)
                            .fill(isDisabled ? styleManager.disabledBackgroundColor : Color.clear)
                    )
                    .disabled(isDisabled) // Use isDisabled here
                    .opacity(isDisabled ? 0.6 : 1.0)
                    .keyboardType(viewModel.config.inputType == .numbersOnly ? .numberPad : .default)
                    .onChange(of: viewModel.text) { (oldValue,newValue) in
                        if !isDisabled {
                            viewModel.validateInput()
                        }
                    }

                    // Suffix
                    if !viewModel.suffixOptions.isEmpty {
                        CustomDropdownView(
                            selectedOption: $viewModel.selectedSuffix,
                            options: viewModel.suffixOptions,
                            label: "Suffix",
                            borderColor: borderColor
                        )
                        .disabled(isDisabled) // Use isDisabled here
                        .opacity(isDisabled ? 0.6 : 1.0)
                    }
                }

                // Error Message
                if let errorMessage = viewModel.errorMessage, viewModel.hasInteracted, !isDisabled {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(styleManager.errorColor)
                        Text(errorMessage)
                            .styledText(font: styleManager.errorFont, color: styleManager.errorColor)
                    }
                }
            }
            .padding(styleManager.componentPadding)
        }
    }
}




