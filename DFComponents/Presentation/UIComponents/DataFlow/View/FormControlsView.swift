//
//  FormControlsView.swift
//  DFComponents
//
//  Created by Eslam on 12/02/2025.
//

import SwiftUI

struct FormControlsView: View {
    @StateObject var viewModel = DataFlowViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                ControlFormBuilderView(titleControl: "First Name") {
                    TextField("Enter your first name", text: $viewModel.firstName)
                        .textInputAutocapitalization(.words)
                        .padding(.all, 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(!viewModel.firstName.isEmpty && viewModel.firstNameError == nil  ? Color.green : Color.gray, lineWidth: 1)
                                .padding(.horizontal, 1)
                        }
                    if let error = viewModel.firstNameError {
                        ErrorMessageView(errorMessage: error, imageName: "xmark.circle.fill")
                    }
                }
                ControlFormBuilderView(titleControl: "Last Name") {
                    TextField("Enter your last name", text: $viewModel.lastName)
                        .textInputAutocapitalization(.words)
                        .padding(.bottom, 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(!viewModel.lastName.isEmpty && viewModel.lastNameError == nil ? Color.green : Color.gray, lineWidth: 1)
                                .padding(.horizontal, 1)
                        }
                    if let error = viewModel.lastNameError {
                        ErrorMessageView(errorMessage: error, imageName: "xmark.circle.fill")
                    }
                }
                ControlFormBuilderView(titleControl: "Full Name") {
                    if viewModel.firstNameError == nil && viewModel.lastNameError == nil {
                        Text(viewModel.fullName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.bottom, 8)
                    } else {
                        ErrorMessageView(errorMessage: "Invalid name entries", imageName: "xmark.circle.fill")
                    }
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    FormControlsView()
}
