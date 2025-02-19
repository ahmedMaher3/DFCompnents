//
//  QuestionsRadioButton.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct QuestionsRadioButton: View {
    @ObservedObject var radioButtonVM: RadioButtonViewModel  // Use ObservedObject to use the passed-in VM
    @EnvironmentObject var viewModel: FormViewModel
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Iterate through the radioButtonModels in the ViewModel
                    ForEach(radioButtonVM.radioButtonModels.keys.sorted(), id: \.self) { questionID in
                        VStack(alignment: .leading) {
                            if let radioButtons = radioButtonVM.radioButtonModels[questionID] {
                                VStack {
                                    ForEach(radioButtons, id: \.id) { button in
                                        Button(action: {
                                            // Handle radio button tap
                                            radioButtonVM.onTapRadioButton(questionID: questionID, item: button)
                                        }) {
                                            HStack {
                                                Text(button.label)
                                                    .foregroundColor(.primary)

                                                if radioButtonVM.selectedItem(for: questionID)?.id == button.id {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.blue)
                                                } else {
                                                    Image(systemName: "circle")
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                        }
                                        .padding(.vertical, 6)
                                    }
                                }
                            }
                            // Show error message if validation fails
                            if let errorMessage = radioButtonVM.validationErrors[questionID], !errorMessage.isEmpty {
                                ErrorMessageView(errorMessage: errorMessage, imageName: "xmark.circle.fill")
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .padding(16)
            }
        }
        .onAppear {
            loadOptionsForRadioButtons()
        }
    }
    
    func loadOptionsForRadioButtons() {
        viewModel.viewModels.values.forEach { viewModel in
//            if let radioButtonVM = viewModel as? RadioButtonViewModel {
//                if let formField = self.viewModel.formFields.first(where: { $0.id == radioButtonVM.fieldId }) {
////                    radioButtonVM.loadOptions(from: formField.properties?.options ?? [])
//                }
//            }
        }
    }
}
