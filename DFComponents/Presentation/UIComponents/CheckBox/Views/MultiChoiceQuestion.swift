//
//  MultiChoiceQuestion.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct MultiChoiceQuestion: View {
    @ObservedObject var checkBoxVM: CheckBoxViewModel
    @State private var showAllAnswersForQuestion: [String: Bool] = [:]

    var body: some View {
        VStack {
            List {
                ForEach(
                    checkBoxVM.questions.indices,
                    id: \.self
                ) { index in
                    let questionID = "question\(index)"
                    VStack(
                        alignment: .leading,
                        spacing: 16
                    ) {
                        Text(
                            checkBoxVM.questions[index]
                        )
                        .font(
                            .headline
                        )
                        .padding(
                            .bottom,
                            4
                        )
                        .padding(
                            .top,
                            16
                        )
                        .color(
                            checkBoxVM.validationErrors[questionID] != nil
                            ? .red : .primary

                        )
                        .onAppear {
                            if showAllAnswersForQuestion[questionID] == nil {
                                showAllAnswersForQuestion[questionID] = false
                            }
                        }
                        let items = checkBoxVM.checkBoxModels[questionID] ?? []
                        let showAll = showAllAnswersForQuestion[questionID] ?? false
                        let displayedItems = showAll ? items : Array(
                            items.prefix(
                                3
                            )
                        ) // Show all or first 3 items


                        ForEach(
                            displayedItems
                        ) { item in
                            CheckBoxView(
                                checkBoxState: checkBoxVM,
                                questionID: questionID,
                                item: item
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        }
                        ShowMoreButton(
                            showAll: showAll,
                            questionID: questionID,
                            itemsCount: items.count, showAllAnswersForQuestion: $showAllAnswersForQuestion
                        )
                        //MARK: - Error
                        if let errorMessage = checkBoxVM.validationErrors[questionID], !errorMessage.isEmpty {
                            ErrorMessageView(
                                errorMessage: errorMessage,
                                imageName: "xmark.circle.fill"
                            )
                        }
                    }
                }
                .listStyle(.automatic)
            }

            SubmitButtonCheckBoxView(
                checkBoxVM: checkBoxVM
            )
        }
    }
}

#Preview {
    MultiChoiceQuestion(
        checkBoxVM: CheckBoxViewModel()
    )
}
