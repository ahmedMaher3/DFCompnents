//
//  TextBoxViewModelStrategy.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//

import Foundation
@MainActor
// TextBoxViewModel specific strategy
class TextBoxViewModelStrategy: FormViewModelStrategy {
    func process(viewModel: any ObservableObject, key: String, formBuilder: FormViewModel) {
        guard let textBoxVM = viewModel as? TextBoxViewModel,
              let textBoxField = textBoxVM.textBoxField else { return }
        formBuilder.updateControlByViewModel(controlId: key)
        print("Display the key:\(key)")
        print("Answer:\(textBoxField.answer) and text base please:\(textBoxField.textBase) and text:\(textBoxVM.text)")
    }
}
