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
    @Published var controls = [FormViewModelItemProtocol]()

    private let viewModelContainer = FormViewModelContainer()
    
    private var formEntity: FormEntity!
    
    func updatevalue(_ id: String, value: String) {
//        formEntity?.updateItem(formEntity?.getItem(by: id))
        formEntity?.updateAnswer(for: id, with: value)
//        viewModels[id] = viewModelContainer.resolve(for: id, field: formEntity)
//        viewModelContainer.registerViewModel(<#T##fieldType: String##String#>) { <#FormEntity#> in
//            <#code#>
//        }
    }

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
        self.formEntity = FormEntity(form)
        print(formEntity)
        controls = self.registerAndResolveField(formEntity)
    }
    
    func registerAndResolveField(_ formEntity: FormEntity) -> [FormViewModelItemProtocol] {
        var formBuilderEntity: FormEntity = formEntity
        formBuilderEntity.items.forEach { fieldControl in
            switch fieldControl.type.rawValue {
                case FieldType.TextBox.rawValue:
                    var textBoxItem = formBuilderEntity.getTextBoxItem(by: fieldControl.fieldId)
                    textBoxItem?.addNote = true
                    formBuilderEntity.updateItem(textBoxItem)
                    print("Test")
                    viewModelContainer.registerViewModel(FieldType.TextBox.rawValue) { formFieldEntity in
                        return TextBoxViewModel(textBoxField: formFieldEntity.getTextBoxItem(by: fieldControl.fieldId))
                    }
                default:
                    break
            }
            if let viewModel = viewModelContainer.resolve(for: fieldControl.type.rawValue, field: formEntity) {
                viewModels[fieldControl.fieldId] = viewModel
            }
        }
        return formEntity.items
    }

    //    func mapFields(_ fields: [Field]) {
    //        formFields = fields.map(FormField.init)
    //        mapControls(formFields)
    //    }
    //
//        func mapControls(_ fields: [FormField]) {
//            fields.forEach { formField in
//                //MARK: - Register Child Controls View Model
//                self.registerField(formField.field)
//                //MARK: - Resolve Child View Models
//                if let viewModel = viewModelContainer.resolve(for: formField.type.rawValue, field: formField.field) {
//                    viewModels[formField.id] = viewModel
//                }
//            }
//        }

    /*
     TextBox
     DropDown
     CheckBox
     */



}
