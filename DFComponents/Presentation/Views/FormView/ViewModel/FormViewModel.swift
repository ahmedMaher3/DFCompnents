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
    @Published var rulesViewModel: RulesControlsViewModel = RulesControlsViewModel()
    
//    @Published var formFields: [FormField] = []
    @Published var formFields: [ControlType] = []

    func fetchForm() {
        if let path = Bundle.main.path(forResource: "checkSurvey", ofType: "json") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

                mapFields(apiResponse.data.schema.fields)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func mapFields(_ fields: [Field]) {
        formFields =  FormUseCase().excute(fields)
    }
}
