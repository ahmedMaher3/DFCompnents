//
//  QuestionsRadioButton.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct QuestionsRadioButton: View {
    @ObservedObject var radioButtonVM: RadioButtonViewModel

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(radioButtonVM.questions.indices, id: \.self) { index in
                        let questionID = "question\(index)"
                        VStack(alignment: .leading) {
                            Text(
                                radioButtonVM.questions[index])
                            .font(.headline)
                            .padding(.bottom, 8)
                            .foregroundColor(radioButtonVM.validationErrors[questionID] != nil ? .red : .primary)

                            RadioButtonView(radioButtonState: radioButtonVM,
                                            questionID: questionID)
                            .frame(maxWidth: .infinity, alignment: .leading)

                            // Display error message if validation fails
                            if let errorMessage = radioButtonVM.validationErrors[questionID], !errorMessage.isEmpty {
                                HStack(alignment: .center) {
                                    Image(systemName: "xmark.circle")
                                    Text(errorMessage)
                                        .font(.subheadline)
                                }
                                .color(.customColor(Color.red))
                                .padding(.top, 4)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .padding(16)
            }
            Button(action: {
                radioButtonVM.validate()
                if radioButtonVM.validationErrors.values.contains(where: { $0.isEmpty == false }) {
                    print("Validation failed: Please answer all questions.")
                } else {
                    print("Form submitted successfully!")
                }
            }) {
                Text("Submit")
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: 100, height: 50)
            }
        }
    }
}
#Preview {
    QuestionsRadioButton(radioButtonVM: RadioButtonViewModel())
}
