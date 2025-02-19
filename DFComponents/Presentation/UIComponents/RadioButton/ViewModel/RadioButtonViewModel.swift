//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation
final class RadioButtonViewModel: ObservableObject {
    @Published var selectedItems: [String: String] = [:]  // Key: Question ID, Value: Selected item ID
    @Published var questions: [String] = [] // Dynamically loaded questions
    @Published var radioButtonModels: [String: [RadioButtonDTO]] = [:] // Key: Question ID, Value: List of options for that question
    @Published var validationErrors: [String: String] = [:]
    @Published var options: [Option]? = []
    var fieldId: String  // Store the question ID directly

    
    var callbackAction: (RadioButtonDTO?) -> Void
    init(fieldId: String, callbackAction: @escaping (RadioButtonDTO?) -> Void = { _ in }) {
        self.fieldId = fieldId
        self.callbackAction = callbackAction
    }

    func loadOptions(from options: [Option]) {
        let radioButtons = options.map { option in
            RadioButtonDTO(id: option.id, label: option.name, value: option.name)
        }
        self.radioButtonModels = [fieldId: radioButtons]
    }
    // Action to toggle the selection state for each question
    func onTapRadioButton(questionID: String, item: RadioButtonDTO) {
        // Check if the current item is selected for this question
        if selectedItems[questionID] == item.id {
            // Deselect if the same item is clicked again
            selectedItems[questionID] = nil
            callbackAction(nil)
            validationErrors[questionID] = "Please select an answer."
        } else {
            // Select the new item
            selectedItems[questionID] = item.id
            callbackAction(item)
            validationErrors[questionID] = nil
        }
    }

    // Get the selected item for a specific question
    func selectedItem(for questionID: String) -> RadioButtonDTO? {
        guard let selectedItemID = selectedItems[questionID] else { return nil }
        let models = radioButtonModels[questionID] ?? []
        return models.first { $0.id == selectedItemID }
    }

    func validate() {
        for (questionId, _) in radioButtonModels {
            if selectedItems[questionId] == nil {
                validationErrors[questionId] = "Please select an answer."
            } else {
                validationErrors[questionId] = nil
            }
        }
        if validationErrors.values.contains(where: { $0.isEmpty == false }) {
            print("Validation failed: Please answer all questions.")
        } else {
            print("Form submitted successfully!")
            // Handle form submission here
        }
    }

    func errorMessage(for questionId: String) -> String? {
        return validationErrors[questionId]
    }
}
