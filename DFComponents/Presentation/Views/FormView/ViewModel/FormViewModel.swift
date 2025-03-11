//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()
    var rules = [Rule]()
    @Published var mode: FormType?
    @Published var fields: [FieldEntity] = []
    @Published var pages: [PageModel] = []
    @Published var rulesImp: RuleImp!
    @Published var warningsDictionary: [String: [String]] = [:] // Stores warnings by field ID
    var warnings: WarningsEntity?

    func fetchForm() async {
        do {
            let response = try await formBuildUseCase.excute()
            mode = response.pages.first?.mode
            pages = response.pages
            fields = pages.flatMap { $0.fields }
            rules = response.rules
            warnings = response.warnings
            self.doRules()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func updateTextBoxValue(fieldId: String, newValue: String) {
        pages = pages.map { page in
            var updatedPage = page
            updatedPage.fields = updatedPage.fields.map { field in
                if case .textBox((let textBoxField, let textBoxViewModel)) = field,
                   textBoxField.fieldId == fieldId {
                    textBoxViewModel.control.label = newValue
                }
                return field
            }
            return updatedPage
        }
    }


    private func doRules() {
        let fields: [BaseFieldProtocol] = fields.map { fieldEntity in
            switch fieldEntity {
            case .textBox((let field, _)):
                return field
            case .radio((let field, _)):
                return field
            case .page((let field, _)):
                return field
            case .section((let field, _)):
                return field
            case .number((let field, _)):
                return field
            }
        }
        rulesImp = RuleImp(controls: fields, rules: rules)
        rulesImp.handleAllRules()
    }

    func applyFieldRules(by id: String) {
        rulesImp.getAffectedRules(forControlId: id)
    }

    func checkingWarning(for fieldId: String, value: Any? = nil) {
        if checkValueIsEmpty(value: value),
           let requiredWarning = warnings?.fieldValidation.required {
            DispatchQueue.main.async {
                self.warningsDictionary[fieldId] = [requiredWarning]
            }
            return
        }
        if let field = fields.first(where: { $0.id == fieldId }) {
            switch field {
                case .textBox((let baseField, _)):
                    self.warningsDictionary[baseField.fieldId] = nil
                case .radio((let baseField, _)):
                    self.warningsDictionary[baseField.fieldId] = nil
                  case .page((let baseField, _)):
                    self.warningsDictionary[baseField.fieldId] = nil
                case .section((let baseField, _)):
                    self.warningsDictionary[baseField.fieldId] = nil
                case .number((let baseField, let numberViewModel)):
                    numberViewModel.validateInput(value: numberViewModel.numberFieldModel.numberAnswer?.value ?? "", warnings: warnings)
                    DispatchQueue.main.async {
                        if let errorMessage = numberViewModel.numberFieldModel.errorMessage, !errorMessage.isEmpty {
                            self.warningsDictionary[baseField.fieldId] = [errorMessage]
                        } else {
                            self.warningsDictionary[baseField.fieldId] = nil
                    }
                }
            }
        }
    }

    ///Check Value Is Empty
    func checkValueIsEmpty(value: Any?) -> Bool {
        switch value {
            case nil:
                return true
            case let collection as any Collection:
                return collection.isEmpty
            case let stringValue as String:
                return stringValue.isEmpty
            default:
                return false
        }
    }
}
