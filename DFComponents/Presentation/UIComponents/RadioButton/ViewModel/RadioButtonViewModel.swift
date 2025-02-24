//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

final class RadioButtonViewModel: FieldViewModelProtocol {

    @Published var control: RadioControlDTO

     init(control: RadioControlDTO) {
         self.control = control
     }

     // When an option is selected, update all options:
     func selectOption(_ option: Option) {
         control.properties.options =  control.properties.options.map{var item = $0; item.isSelected = false; return item}
         if let index = control.properties.options.firstIndex(where: {$0.id == option.id}) {
             control.properties.options[index].isSelected = true
         }
     }

//    @Published var selectedItems: [String: String] = [:]  // Key: Question ID, Value: Selected item ID
//    @Published var questions: [String] = [
//        "What's your fav color ahmed?",
//    ]
//    @Published var radioButtonModels: [String: [RadioButtonDTO]] = [
//        "question0": RadioButtonDTO.elementsRadioButton,
//    ]
//    @Published var validationErrors: [String: String] = [:]
//
//    var callbackAction: (RadioButtonDTO?) -> Void
//
//    init(callbackAction: @escaping (RadioButtonDTO?) -> Void = { _ in }) {
//        self.callbackAction = callbackAction
//    }
//
//    // Action to toggle the selection state for each question
//    func onTapRadioButton(questionID: String, item: RadioButtonDTO) {
//        // Check if the current item is selected for this question
//        if selectedItems[questionID] == item.id {
//            // Deselect if the same item is clicked again
//            selectedItems[questionID] = nil
//            callbackAction(nil)
//            validationErrors[questionID] = "Please select an answer."
//        } else {
//            // Select the new item
//            selectedItems[questionID] = item.id
//            callbackAction(item)
//            validationErrors[questionID] = nil
//        }
//    }
//    // Get the selected item for a specific question
//    func selectedItem(for questionID: String) -> RadioButtonDTO? {
//        guard let selectedItemID = selectedItems[questionID] else { return nil }
//        let models = radioButtonModels[questionID] ?? []
//        return models.first { $0.id == selectedItemID }
//    }
//    func validate() {
//        for(questionId, _) in radioButtonModels {
//            if selectedItems[questionId] == nil {
//                validationErrors[questionId] = "Please select an answer."
//            } else {
//                validationErrors[questionId] = nil
//            }
//        }
//        if validationErrors.values.contains(where: { $0.isEmpty == false }) {
//            print("Validation failed: Please answer all questions.")
//        } else {
//            print("Form submitted successfully!")
//            // Handle form submission here
//        }
//    }
//    func errorMessage(for questionId: String) -> String? {
//        return validationErrors[questionId]
//    }
}

