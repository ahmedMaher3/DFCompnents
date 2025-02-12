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
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .padding(.bottom, 8)
                }
                ControlFormBuilderView(titleControl: "Last Name") {
                    TextField("Enter your last name", text: $viewModel.lastName)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .padding(.bottom, 8)
                }
                ControlFormBuilderView(titleControl: "Full Name") {
                    Text(viewModel.fullName)
                }
            }
        }
        .padding(16)
    }
}

#Preview {
    FormControlsView()
}
