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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                // DropDownView
                DropDownView(title: "Select Country", viewModel: viewModel.dropdownViewModel)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal)
                
                // TextBoxComponent
                TextBoxComponent(viewModel: viewModel.textBoxViewModel)
                    .listRowSeparator(.hidden)
                
                // DateTimeView
                DateTimeView(viewModel: viewModel.dateFieldViewModel) // Added here
                    .listRowSeparator(.hidden)
                MultiChoiceQuestion(checkBoxVM: viewModel.checkBoxViewModel)
                QuestionsRadioButton(radioButtonVM: viewModel.radioButtonViewModel)
            }
            .padding(.top, 10)
            .listRowSeparator(.hidden)
            .listStyle(PlainListStyle())
            
            // Buttons at the bottom
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Submit action
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FormView(viewModel: FormViewModel(), title: "Form Title")
}
