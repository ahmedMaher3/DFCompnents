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
//        "What's your favorite multicolor, hassan?",
//        "What's your favorite multicolor, nasr?"
    ]
    @Published var checkBoxModels: [String: [CheckBoxDTO]] = [:] // Dynamically populated later

    @Published var validationErrors: [String: String] = [:]

    var callbackAction: (CheckBoxDTO?) -> Void

    init(callbackAction: @escaping (CheckBoxDTO?) -> Void = { _ in }) {
        self.callbackAction = callbackAction
        self.loadCheckBoxModels()
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
    func questionsList() -> [CheckBoxDTO] {
        return [
            CheckBoxDTO(id: "1", name: "Red"),
            CheckBoxDTO(id: "2", name: "Green"),
            CheckBoxDTO(id: "3", name: "Blue"),
            CheckBoxDTO(id: "4", name: "Yellow"),
//            CheckBoxDTO(id: "5", name: "Purple"),
//            CheckBoxDTO(id: "6", name: "Orange"),
//            CheckBoxDTO(id: "7", name: "Pink"),
//            CheckBoxDTO(id: "8", name: "Brown"),
//            CheckBoxDTO(id: "9", name: "Black"),
//            CheckBoxDTO(id: "10", name: "White")
        ]
    }

    func loadCheckBoxModels() {
        // Populate checkBoxModels with a list of CheckBoxDTOs for each question
        for (index, _) in questions.enumerated() {
            let questionID = "question\(index)"
            checkBoxModels[questionID] = questionsList() // Use the same questionsList for all questionIDs
        }
    }

}
