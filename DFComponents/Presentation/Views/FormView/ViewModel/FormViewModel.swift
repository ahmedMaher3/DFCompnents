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
    var warnings: WarningsEntity?

    private var fieldsDictionary: [String: FieldEntity] = [:]

    @Published var mode: FormType?
    @Published var fields: [FieldEntity] = []
    @Published var pages: [PageModel] = []
    @Published var rulesImp: RuleImp!

    /// Stores warnings by field ID
    @Published var warningsDictionary: [String: [String]?] = [:]


    func fetchForm() async {
        do {
            let response = try await formBuildUseCase.excute()
            mode = response.pages.first?.mode
            pages = response.pages
            fields = pages.flatMap { $0.fields }
            fieldsDictionary = Dictionary(uniqueKeysWithValues: fields.map { ($0.id, $0) })
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
        guard let field = fieldsDictionary[fieldId] else { return }

        if case .number((_, let numberViewModel)) = field {
            numberViewModel.validateInput(
                value: numberViewModel.baseAnswer?.value ?? "",
                warnings: warnings,
                warningsDictionary: &warningsDictionary)
        }
    }
}
