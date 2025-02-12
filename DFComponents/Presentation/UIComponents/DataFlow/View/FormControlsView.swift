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
        NavigationStack {
            Form {
                Section("Name") {
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
                                .padding(.all, 8)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(!viewModel.lastName.isEmpty && viewModel.lastNameError == nil  ? Color.green : Color.gray, lineWidth: 1)
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
                Section("Email") {
                    ControlFormBuilderView(titleControl: "Email") {
                        TextField("Enter your email", text: $viewModel.email)
                            .textInputAutocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(.all, 8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke((viewModel.emailError == nil && !viewModel.email.isEmpty) ? Color.green : Color.gray, lineWidth: 1)
                                    .padding(.horizontal, 1)
                            }
                        if let error = viewModel.emailError {
                            ErrorMessageView(errorMessage: error, imageName: "xmark.circle.fill")
                        }
                    }
                    ControlFormBuilderView(titleControl: "Confirm Email") {
                        TextField("Confirm your email", text: $viewModel.confirmEmail)
                            .textInputAutocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(.all, 8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.isEmailMatching && (viewModel.confirmEmailError == nil && !viewModel.confirmEmail.isEmpty) && viewModel.confirmEmailError == nil ? Color.green : Color.gray, lineWidth: 1)
                                    .padding(.horizontal, 1)
                            }
                        if let error = viewModel.confirmEmailError {
                            ErrorMessageView(errorMessage: error, imageName: "xmark.circle.fill")
                        }
                    }
                }
                Section("Media") {
                    ControlFormBuilderView(titleControl: "Camera Picker") {
                        FilePickerView()
                    }
                }
                NavigationLink {
                    DisplayDataFormView(viewModel: viewModel)
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(0)
    }
}

#Preview {
    FormControlsView(viewModel: DataFlowViewModel())
}

