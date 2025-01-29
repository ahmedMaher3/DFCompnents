//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation


final class RadioButtonViewModel: ObservableObject {

    @Published var selectedItems: [String: RadioButtonModel] = [:]  // Key: Question ID, Value: Selected item

    var callbackAction: (RadioButtonModel?) -> Void

    init(callbackAction: @escaping (RadioButtonModel?) -> Void = { _ in }) {
        self.callbackAction = callbackAction
    }

    // Action to toggle the selection state for each question
    func onTapRadioButton(questionID: String, item: RadioButtonModel) {
        if selectedItems[questionID]?.id == item.id {
            // Deselect if the same item is clicked again
            selectedItems[questionID] = nil
            callbackAction(nil)
        } else {
            // Select the new item
            selectedItems[questionID] = item
            callbackAction(item)
        }
    }

    // Get the selected item for a specific question
    func selectedItem(for questionID: String) -> RadioButtonModel? {
        return selectedItems[questionID]
    }
}
