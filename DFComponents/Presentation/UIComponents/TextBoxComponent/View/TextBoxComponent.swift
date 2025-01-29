//
//  TextBoxComponent.swift
//  LOTRConverter
//
//  Created by hassan elshaer on 28/01/2025.

import SwiftUI

struct TextBoxComponent: View {
    @ObservedObject var viewModel: TextBoxViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title)
                    .font(.headline)
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            // Input Field with Prefix and Suffix
            HStack {
//                if let prefix = viewModel.prefix {
//                    Text(prefix)
//                        .padding(.horizontal)
//                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//                }

                TextField(viewModel.placeholder, text: $viewModel.text, onEditingChanged: { isEditing in
                    viewModel.onEditingChanged(isEditing: isEditing)
                })
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.borderColor, lineWidth: 2))
                .keyboardType(viewModel.config.inputType == .numbersOnly ? .numberPad : .default)
                .onChange(of: viewModel.text) { _ in
                    viewModel.validateInput()
                }

//                if let suffix = viewModel.suffix {
//                    Text(suffix)
//                        .padding(.horizontal)
//                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//                }
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage, viewModel.hasInteracted {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

#Preview {
    let config = TextBoxConfiguration(
        title: "What is your Name?",
        subtitle: nil,
        placeholder: "Enter your name",
        inputType: .mixed,
        minLength: 2,
        prefix: "Prefix",
        suffix: "Suffix"
    )
    return  TextBoxComponent(viewModel: TextBoxViewModel(config: config))
}
