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
                                ErrorMessageView(errorMessage: errorMessage)
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .padding(16)
            }
            SubmitButtonView(radioButtonState: radioButtonVM)
        }
    }
}
#Preview {
    QuestionsRadioButton(radioButtonVM: RadioButtonViewModel())
}
