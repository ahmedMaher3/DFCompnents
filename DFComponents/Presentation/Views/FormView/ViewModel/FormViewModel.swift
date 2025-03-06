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
    @Published var warningsDictionary: [String: [String]] = [:] // Stores warnings by field ID

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

    func checkingWarning(for fieldId: String, value: Any?, isError: Bool) {
        guard let warnings else { return }
        var fieldWarnings: [String] = []
//        let isValueEmpty: Bool = {
//            switch value {
//                case let stringValue as String: return stringValue.isEmpty
//                default: return false
//            }
//        }()
        let isValueEmpty: Bool = {
              if let value = value as? any Collection {
                  return value.isEmpty
              } else if let value = value as? any CustomStringConvertible {
                  return value.description.isEmpty
              } else {
                  return value == nil
              }
          }()

        if isValueEmpty, let requiredWarning = warnings.fieldValidation.required {
            fieldWarnings.append(requiredWarning)
        }

        if let field = fields.first(where: { $0.id == fieldId }) {
            switch field {
                case .textBox((let baseField, _)),
                        .radio((let baseField, _)),
                        .number((let baseField, _)):
                    if let numericWarning = warnings.fieldValidation.input.numeric, isError {
                        fieldWarnings.append(numericWarning)
                    }
                    warningsDictionary[baseField.fieldId] = fieldWarnings
            }
        }
    }
}
