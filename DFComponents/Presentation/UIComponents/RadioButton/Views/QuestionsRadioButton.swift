//
//  QuestionsRadioButton.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct QuestionsRadioButton: View {
    
    @StateObject var radioButtonVM: RadioButtonViewModel = RadioButtonViewModel()

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

                            RadioButtonView(radioButtonVM: radioButtonVM,
                                            questionID: questionID)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            if let errorMessage = radioButtonVM.validationErrors[questionID], !errorMessage.isEmpty {
                                ErrorMessageView(errorMessage: errorMessage, imageName: "xmark.circle.fill")
                            }
                        }
                        .padding(.bottom, 16)
                    }
                }
                .padding(16)
            }
            SubmitButtonView(viewModel: radioButtonVM)
        }
    }
}
#Preview {
    QuestionsRadioButton(radioButtonVM: RadioButtonViewModel())
}
