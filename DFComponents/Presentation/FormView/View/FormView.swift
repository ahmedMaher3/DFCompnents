//
//  FormView.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

struct FormView: View {
    @StateObject var viewModel: FormViewModel = FormViewModel()
    var title: String = ""
    
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 10)
        .listRowSeparator(.hidden)
        .listStyle(PlainListStyle())
    }
}

#Preview {
    FormView(viewModel: FormViewModel())
}
