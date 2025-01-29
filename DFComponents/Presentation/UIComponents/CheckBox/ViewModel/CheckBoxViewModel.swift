//
//  CheckBoxViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation
final class CheckBoxViewModel: ObservableObject {

    @Published var selectedItems: [String: Set<String>] = [:] // Key: Question ID, Value: Set of selected item IDs
    @Published var questions: [String] = [
        "What's your favorite multicolor, ahmed?",
        "What's your favorite multicolor, hassan?",
        "What's your favorite multicolor, nasr?"
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
        if selectedItems[questionID]?.isEmpty ?? true {
            validationErrors[questionID] = "ياعم اختار اجابة واحدة الله يرضي عليك."
        } else {
            validationErrors[questionID] = nil
        }
    }
    func selectedItems(for questionID: String) -> Set<CheckBoxModel> {
        guard let selectedItemIDs = selectedItems[questionID] else { return [] }
        let models = checkBoxModels[questionID] ?? []
        return Set(models.filter { selectedItemIDs.contains($0.id) })
    }
    func validate() {
        validationErrors.removeAll()

        for (questionID, _) in checkBoxModels {
            if selectedItems[questionID]?.isEmpty ?? true {
                validationErrors[questionID] = "ياعم اختار اجابة واحدة الله يرضي عليك."
            }
        }
    }

    // Get the error message for a specific question
    func errorMessage(for questionID: String) -> String? {
        return validationErrors[questionID]
    }
}
