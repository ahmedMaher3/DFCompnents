//
//  CheckBoxViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation
final class CheckBoxViewModel: ObservableObject {

    // Store selected items as a set for each question
    @Published var selectedItems: [String: Set<String>] = [:] // Key: Question ID, Value: Set of selected item IDs
    @Published var questions: [String] = [
        "What's your fav color?",
        "What's your fav animal?",
        "What's your fav food?"
    ]
    @Published var checkBoxModels: [String: [CheckBoxModel]] = [
        "question0": CheckBoxModel.elementsCheckBox,
        "question1": CheckBoxModel.elementsCheckBox,
        "question2": CheckBoxModel.elementsCheckBox
    ]
    @Published var validationErrors: [String: String] = [:]

    var callbackAction: (CheckBoxModel?) -> Void

    init(callbackAction: @escaping (CheckBoxModel?) -> Void = { _ in }) {
        self.callbackAction = callbackAction
    }

    // Action to toggle the selection state for each checkbox item
    func onTapCheckBox(questionID: String, item: CheckBoxModel) {
        if selectedItems[questionID]?.contains(item.id) == true {
            // Deselect if the same item is clicked again
            selectedItems[questionID]?.remove(item.id)
            callbackAction(nil)
        } else {
            // Select the new item
            selectedItems[questionID, default: Set<String>()].insert(item.id)
            callbackAction(item)
        }
        validate()
    }

    // Get the selected items for a specific question
    func selectedItems(for questionID: String) -> Set<CheckBoxModel> {
        guard let selectedItemIDs = selectedItems[questionID] else { return [] }
        let models = checkBoxModels[questionID] ?? []
        return Set(models.filter { selectedItemIDs.contains($0.id) })
    }

    // Validate that at least one item is selected for each question
    func validate() {
        for (questionID, _) in checkBoxModels {
            if selectedItems[questionID]?.isEmpty == true {
                validationErrors[questionID] = "Please select at least one option."
            } else {
                validationErrors[questionID] = nil
            }
        }
    }

    // Get the error message for a specific question
    func errorMessage(for questionID: String) -> String? {
        return validationErrors[questionID]
    }
}
