//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {

    @Published var fieldsViewModel: [FieldDTOEnum: any ObservableObject] = [:]
    @Published var formFields: [FieldDTOEnum] = []

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()


    func fetchForm() async {
        do {
            formFields =  try await formBuildUseCase.excute()
            let arrayOfDicts = formFields.map { FieldViewModelFactory.make(from: $0) }
            self.fieldsViewModel = arrayOfDicts.reduce([:]) { $0.merging($1) { current, _ in current } }

        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}

struct FieldViewModelFactory {
    static func make(from field: FieldDTOEnum) -> [FieldDTOEnum: any ObservableObject] {
        var viewModelsByType: [FieldDTOEnum: any ObservableObject] = [:]
            switch field {
            case .textBox(let textBoxControl):
                let vm = TextBoxViewModel()
                viewModelsByType[field] = vm
            case .radio(let radioControl):
                let vm = RadioButtonViewModel(control: radioControl)
                viewModelsByType[field] = vm
            }
        return viewModelsByType
    }
}
