//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI
/*
 func updatevalue(_ id: String, value: String) {
 //        formEntity?.updateItem(formEntity?.getItem(by: id))
 formEntity?.updateAnswer(for: id, with: value)
 let texBoxVM = viewModels[id] as! TextBoxViewModel
 texBoxVM.textBoxField?.answer = value

 viewModels[id] = texBoxVM

 }
 */
@MainActor
class FormViewModel: ObservableObject {

    @Published var viewModels: [String: any ObservableObject] = [:]
    //    @Published var formFields: [FormField] = []
    @Published var controls = [FormViewModelItemProtocol]()

    private let viewModelContainer = FormViewModelContainer()

    private var formEntity: FormEntity!


    func updateControlByViewModel(controlId: String) {
        switch formEntity.getItem(by: controlId)?.type {
            case .TextBox:
                if let textBoxViewModel = viewModels[controlId] as? TextBoxViewModel {
                    textBoxViewModel.validateInput()
                    //MARK: - Approach
                    /*
                     1. textBoxViewModel.textBoxField?.answer =  textBoxViewModel.getAnswer()
                     2. textBoxViewModel.textBoxField?.rules = textBoxViewModel.getRules()
                     and so on ...
                     */
                    /// answer = viewModel itself this is just example
                    textBoxViewModel.textBoxField?.answer = textBoxViewModel
                    formEntity.updateAnswer(for: controlId, with: textBoxViewModel)
                    if let answer = textBoxViewModel.textBoxField?.answer {
                        print("Updated answer: \(answer)")
                    } else {
                        print("Answer is nil")
                    }
                } else {
                    // Handle the case where the view model couldn't be resolved
                    print("Failed to resolve view model for controlId: \(controlId)")
                }
                break
            default:
                break
        }
    }

    /*
     you need to update dataSource for control related to specific view model
     (control id, viewModel X, formEntity)
     viewModelContainer.resolve(for: id, field: formEntity)

     */
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
        controls = self.registerAndResolveField(formEntity)
    }
    func registerAndResolveField(_ formEntity: FormEntity) -> [FormViewModelItemProtocol] {
        let formBuilderEntity: FormEntity = formEntity
        formBuilderEntity.items.forEach { fieldControl in
            switch fieldControl.type.rawValue {
                case FieldType.TextBox.rawValue:
                    viewModelContainer.registerViewModel(FieldType.TextBox.rawValue) { formFieldEntity in
                        TextBoxViewModel(textBoxField: formFieldEntity.getTextBoxItem(by: fieldControl.fieldId))
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



}
/*
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

 //MARK: - First Approach using Closure
 /*
  - How to update control in view model
  - Listen the changes
  - update DataSource @Published var controls = [FormViewModelItemProtocol]()
  - bla bla bla bla


  */

 func updatevalue(_ id: String, value: String) {
 //        formEntity?.updateItem(formEntity?.getItem(by: id))
 formEntity?.updateAnswer(for: id, with: value)
 let texBoxVM = viewModels[id] as! TextBoxViewModel
 texBoxVM.textBoxField?.answer = value
 //        if texBoxVM.textBoxField?.rules?.effectIn {
 //            pqpqw[ewqp eqw]qwe[qw[e]]
 //            formEntity.rules =qw qwe9qwe-
 //        }
 viewModels[id] = texBoxVM
 //        let itemType = formEntity.getItem(by: id)?.type.rawValue ?? ""
 //        viewModelContainer.registerViewModel(itemType) { _ in
 //            TextBoxViewModel(textBoxField: self.formEntity.getTextBoxItem(by: id))
 //        }
 //        viewModelContainer
 //        viewModels[id] = viewModelContainer.resolve(for: id, field: formEntity)
 //        viewModelContainer.registerViewModel(<#T##fieldType: String##String#>) { <#FormEntity#> in
 //            <#code#>
 //        }
 }
 */
