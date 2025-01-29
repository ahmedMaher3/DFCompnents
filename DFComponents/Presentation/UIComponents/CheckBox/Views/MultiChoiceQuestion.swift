//
//  MultiChoiceQuestion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct MultiChoiceQuestion: View {
    @ObservedObject var checkBoxVM: CheckBoxViewModel
    var body: some View {
        VStack {
            List {
                ForEach(checkBoxVM.questions.indices, id: \.self) { index in
                    let questionID = "question\(index)"
                    VStack(alignment: .leading, spacing: 16) {
                        Text(checkBoxVM.questions[index])
                            .font(.headline)
                            .padding(.bottom, 4)
                            .padding(.top, 16)
                            .color(checkBoxVM.validationErrors[questionID] != nil ? .customColor(.red) : .customColor(.primary))

                        ForEach(checkBoxVM.checkBoxModels[questionID] ?? []) { item in
                            CheckBoxView(checkBoxState: checkBoxVM, questionID: questionID, item: item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    //MARK: - Error
                    if let errorMessage = checkBoxVM.validationErrors[questionID], !errorMessage.isEmpty {
                        ErrorMessageView(errorMessage: errorMessage)
                    }
                }
            }
            .listStyle(.automatic)
            // Submit Button
            SubmitButtonView(checkBoxState: checkBoxVM)
        }
        .padding(0)
    }
}

#Preview {
    MultiChoiceQuestion(checkBoxVM: CheckBoxViewModel())
}
