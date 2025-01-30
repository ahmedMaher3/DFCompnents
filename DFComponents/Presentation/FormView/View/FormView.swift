//
//  FormView.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

struct FormView: View {
    @StateObject var viewModel: FormViewModel

    var body: some View {
        List {
            // DropDownView
            DropDownView(title: "Select Country", viewModel: viewModel.dropdownViewModel)
                .listRowSeparator(.hidden)
                .padding(.horizontal)
            
            // TextBoxComponent
            TextBoxComponent(viewModel: viewModel.textBoxViewModel)
                .listRowSeparator(.hidden)
            
            // DateTimeView
            DateTimeView(viewModel: viewModel.dateFieldViewModel)  // Added here
                .listRowSeparator(.hidden)
            MultiChoiceQuestion(checkBoxVM: viewModel.checkBoxViewModel)
        }
        .padding(.top, 10)
        .listRowSeparator(.hidden)
        .listStyle(PlainListStyle())
    }
}

#Preview {
    let textBoxConfig = TextBoxDTO(
        title: "What is your Name?",
        subtitle: nil,
        placeholder: "Enter your name",
        inputType: .mixed,
        minLength: 2,
        prefixOptions: ["Mr", "Ms"],
        suffixOptions: ["Jr"],
        requiresPrefix: true,
        requiresSuffix: true
    )
    
    return FormView(viewModel: FormViewModel(textBoxConfig: textBoxConfig))
}
