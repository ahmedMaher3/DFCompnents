//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {
    
    @Published var viewModels: [String: any ObservableObject] = [:]
//    @Published var formFields: [FormField] = []
    
    private let viewModelContainer = FormViewModelContainer()
    
    func fetchForm() {
        if let path = Bundle.main.path(forResource: "checkSurvey", ofType: "json") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
//                mapFields(apiResponse.data.schema.fields)
                mapForm(apiResponse.data.schema)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func mapForm(_ form: Schema) {
        let formEntity = FormEntity(form)
        print(formEntity)
    }
    
//    func mapFields(_ fields: [Field]) {
//        formFields = fields.map(FormField.init)
//        mapControls(formFields)
//    }
//    
//    func mapControls(_ fields: [FormField]) {
//        fields.forEach { formField in
//            //MARK: - Register Child Controls View Model
//            self.registerField(formField.field)
//            //MARK: - Resolve Child View Models
//            if let viewModel = viewModelContainer.resolve(for: formField.type.rawValue, field: formField.field) {
//                viewModels[formField.id] = viewModel
//            }
//        }
//    }
    
    func registerField(_ field: Field) {
        switch field.type.rawValue {
            case FieldType.Radio.rawValue:
                viewModelContainer.registerViewModel(FieldType.Radio.rawValue) { field in
                    RadioButtonViewModel(fieldId: field.id ?? "")
                }
            default:
                break
        }
    }
}
