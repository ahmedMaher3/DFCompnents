//
//  MultiChoiceQuestion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct MultiChoiceQuestion: View {
    @StateObject var checkBoxVM: CheckBoxViewModel
    
    @State private var showAllAnswersForQuestion: [String: Bool] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(checkBoxVM.questions.indices, id: \.self) { index in
                let questionID = "question\(index)"
                VStack(alignment: .leading, spacing: 16) {
                    Text(checkBoxVM.questions[index])
                        .font(.headline)
                        .padding(.bottom, 4)
                        .padding(.top, 16)
                        .foregroundColor(checkBoxVM.validationErrors[questionID] != nil ? .red : .primary)
                        .onAppear {
                            if showAllAnswersForQuestion[questionID] == nil {
                                showAllAnswersForQuestion[questionID] = false
                            }
                        }
                    
                    let items = checkBoxVM.checkBoxModels[questionID] ?? []
                    let showAll = showAllAnswersForQuestion[questionID] ?? false
                    let displayedItems = showAll ? items : Array(items.prefix(3))
                    
                    ForEach(displayedItems) { item in
                        CheckBoxView(checkBoxVM: checkBoxVM, questionID: questionID, item: item)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    ShowMoreButton(
                        showAll: showAll,
                        questionID: questionID,
                        itemsCount: items.count,
                        showAllAnswersForQuestion: $showAllAnswersForQuestion
                    )
                    
                    // Error Message Display
                    if let errorMessage = checkBoxVM.validationErrors[questionID], !errorMessage.isEmpty {
                        ErrorMessageView(errorMessage: errorMessage, imageName: "xmark.circle.fill")
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MultiChoiceQuestion(
        checkBoxVM: CheckBoxViewModel()
    )
}
