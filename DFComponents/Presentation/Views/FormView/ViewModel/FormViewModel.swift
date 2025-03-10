//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {

    @Published var fields: [FieldEntity] = []
    @Published var rulesImp: RuleImp!
    @Published var errorMessage: String?
    @Published var warningsDictionary: [String: [String]] = [:]

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()
    var rules = [Rule]()
    var warnings: WarningsEntity?

    func fetchForm() async {
        do {
            let response =  try await formBuildUseCase.excute()
            fields = response.fields
            rules = response.rules
            warnings = response.warnings
            self.doRules()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func doRules() {
        let fields: [BaseFieldProtocol] = fields.map { fieldEntity in
            switch fieldEntity {
                case .textBox((let field, _)):
                    return field
                case .radio((let field, _)):
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
        
        if let field = fields.first(where: { $0.id == fieldId }),
           case .number((_, let numberViewModel)) = field {
            numberViewModel.validateInput(value: numberViewModel.numberFieldModel.numberAnswer?.value ?? "", warnings: warnings)
            DispatchQueue.main.async {
                // Store warnings separately for each field
                if let errorMessage = numberViewModel.numberFieldModel.errorMessage, !errorMessage.isEmpty {
                    self.warningsDictionary[fieldId] = [errorMessage]
                } else {
                    self.warningsDictionary[fieldId] = nil
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
