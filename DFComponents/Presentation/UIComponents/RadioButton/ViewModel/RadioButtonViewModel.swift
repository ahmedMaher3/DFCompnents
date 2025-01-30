//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

final class RadioButtonViewModel: ObservableObject {

    @Published var selectedItems: [String: String] = [:]  // Key: Question ID, Value: Selected item ID
    @Published var questions: [String] = [
        "What's your fav color ahmed?",
        "What's your fav hassan?",
        "What's your fav nasr?"
    ]
    @Published var radioButtonModels: [String: [RadioButtonModel]] = [
        "question0": RadioButtonModel.elementsRadioButton,
        "question1": RadioButtonModel.elementsRadioButton,
        "question2": RadioButtonModel.elementsRadioButton
    ]
    @Published var validationErrors: [String: String] = [:]

    var callbackAction: (RadioButtonModel?) -> Void

    init(callbackAction: @escaping (RadioButtonModel?) -> Void = { _ in }) {
        self.callbackAction = callbackAction
    }

    // Action to toggle the selection state for each question
    func onTapRadioButton(questionID: String, item: RadioButtonModel) {
        // Check if the current item is selected for this question
        if selectedItems[questionID] == item.id {
            // Deselect if the same item is clicked again
            selectedItems[questionID] = nil
            callbackAction(nil)
            validationErrors[questionID] = "جاوب علي ام السؤال."
        } else {
            // Select the new item
            selectedItems[questionID] = item.id
            callbackAction(item)
            validationErrors[questionID] = nil
        }
    }
    // Get the selected item for a specific question
    func selectedItem(for questionID: String) -> RadioButtonModel? {
        guard let selectedItemID = selectedItems[questionID] else { return nil }
        let models = radioButtonModels[questionID] ?? []
        return models.first { $0.id == selectedItemID }
    }
    func validate() {
        for(questionId, _) in radioButtonModels {
            if selectedItems[questionId] == nil {
                validationErrors[questionId] = "جاوب علي ام السؤال."
            } else {
                validationErrors[questionId] = nil
            }
        }
    }
    func errorMessage(for questionId: String) -> String? {
        return validationErrors[questionId]
    }
}

