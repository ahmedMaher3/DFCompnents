//
//  CheckBoxViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation
final class CheckBoxViewModel: ObservableObject, SubmitControlProtocol {

    @Published var selectedItems: [String: Set<String>] = [:] // Key: Question ID, Value: Set of selected item IDs
    @Published var questions: [String] = [
        "What's your favorite multicolor, ahmed?",
        "What's your favorite multicolor, hassan?",
        "What's your favorite multicolor, nasr?"
    ]
    @Published var checkBoxModels: [String: [CheckBoxDTO]] = [
        "question0": CheckBoxDTO.elementsCheckBox,
        "question1": CheckBoxDTO.elementsCheckBox,
        "question2": CheckBoxDTO.elementsCheckBox
    ]
    @Published var validationErrors: [String: String] = [:]

    var callbackAction: (CheckBoxDTO?) -> Void

    init(callbackAction: @escaping (CheckBoxDTO?) -> Void = { _ in }) {
        self.callbackAction = callbackAction
    }

    // Action to toggle the selection state for each checkbox item
    func onTapCheckBox(questionID: String, item: CheckBoxDTO) {
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
            validationErrors[questionID] = "Please select at least one answer."
        } else {
            validationErrors[questionID] = nil
        }
    }
    func selectedItems(for questionID: String) -> Set<CheckBoxDTO> {
        guard let selectedItemIDs = selectedItems[questionID] else { return [] }
        let models = checkBoxModels[questionID] ?? []
        return Set(models.filter { selectedItemIDs.contains($0.id) })
    }
    func validate() {
        validationErrors.removeAll()
        for (questionID, _) in checkBoxModels {
            if selectedItems[questionID]?.isEmpty ?? true {
                validationErrors[questionID] = "Please select at least one answer."
            }
        }
        if validationErrors.values.contains(where: { $0.isEmpty == false }) {
            print("Validation failed: Please answer all questions.")
        } else {
            print("Form submitted successfully!")
            // Handle form submission here
        }
    }

    // Get the error message for a specific question
    func errorMessage(for questionID: String) -> String? {
        return validationErrors[questionID]
    }
}
