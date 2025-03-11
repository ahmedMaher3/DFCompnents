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
    

    func checkingWarning(for fieldId: String, value: Any?, isError: Bool) {
        guard let warnings else { return }
        var fieldWarnings: [String] = []

        if checkValueIsEmpty(value: value),
           let requiredWarning = warnings.fieldValidation.required {
            fieldWarnings.append(requiredWarning)
        }

        if let field = fields.first(where: { $0.id == fieldId }) {
            switch field {
                case .page((let baseField, _)): break
                case .section((let baseField, _)): break
                case .textBox((let baseField, _)): break
                case .radio((let baseField, _)): break
                case .number((let baseField, let numberViewModel)):
                    let inputValue = numberViewModel.inputValue
                    ///  Check if input contains letters (Only allow numbers)
                    if inputValue.rangeOfCharacter(from: CharacterSet.letters) != nil {
                        if let numericWarning = warnings.fieldValidation.input.numeric {
                            fieldWarnings.append(numericWarning) // "Please Insert Only Number"
                        }
                    } else if inputValue.contains(".") {
                        ///  Validate Decimal Places
                        if !numberViewModel.validateDecimalPlaces(),
                           let customWarning = warnings.fieldValidation.input.custom {
                            fieldWarnings.append(customWarning.replacingOccurrences(of: "{0}", with: "invalid decimal places".localized))
                        }
                    } else {
                        /// Convert inputValue to Int
                        if let inputNumber = Int(inputValue) {
                            //  Check Minimum Value
                            if let minValue = Int(warnings.fieldValidation.number.minimumValue ?? ""),
                               inputNumber < minValue {
                                fieldWarnings.append("Minimum value allowed is \(minValue)")
                            }
                            ///  Check Maximum Value
                            if let maxValue = Int(warnings.fieldValidation.number.maximumValue ?? ""),
                               inputNumber > maxValue {
                                fieldWarnings.append("Maximum value allowed is \(maxValue) \n")
                            }
                        }
                        ///  Check Maximum Digits (Only if input is fully numeric)
                        if let maxDigits = numberViewModel.numberFieldModel.maximumDigits,
                           inputValue.count > maxDigits {
                            fieldWarnings.append("Maximum digits allowed is \(maxDigits) \n")
                        }
                    }
                    let statusWarnings = !fieldWarnings.isEmpty
                    if numberViewModel.numberFieldModel.isError != statusWarnings {
                        numberViewModel.numberFieldModel.isError = statusWarnings
                    }
                    warningsDictionary[baseField.fieldId] = fieldWarnings
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
