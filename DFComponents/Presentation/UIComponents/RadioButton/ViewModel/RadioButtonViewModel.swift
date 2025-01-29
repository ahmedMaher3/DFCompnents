//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

final class RadioButtonViewModel: ObservableObject {

    @Published var itemValue: String
    @Published var selectedItem: String?
    var callbackAction: (String) -> Void

    init(itemValue: String = "Red", selectedItem: String? = nil, callbackAction: @escaping (String) -> Void = { _ in }) {
        self.itemValue = itemValue
        self.selectedItem = selectedItem ?? ""
        self.callbackAction = callbackAction
    }

    //MARK: - Actions
    func onTapRadioButton() {
        if  selectedItem == itemValue {
            selectedItem = nil
        } else {
            selectedItem = itemValue
        }
        callbackAction(itemValue)
    }
}
