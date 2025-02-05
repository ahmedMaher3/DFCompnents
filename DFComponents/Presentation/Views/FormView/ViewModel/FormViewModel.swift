//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {
    @Published var dropdownViewModel: DropDownViewModel = DropDownViewModel()
    @Published var dateFieldViewModel: DateFieldViewModel = DateFieldViewModel()
    @Published var checkBoxViewModel: CheckBoxViewModel = CheckBoxViewModel()
    @Published var radioButtonViewModel: RadioButtonViewModel = RadioButtonViewModel()
    @Published var textBoxViewModel: TextBoxViewModel = TextBoxViewModel()
    @Published var signatureViewModel: SignatureViewModel = SignatureViewModel()
    @Published var sliderViewModel: SliderViewModel = SliderViewModel()
    
}
