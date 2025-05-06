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

    @Published var mode: FormType?
   // @Published var fields: [FieldEntity] = []
    @Published var pages: [PageModel] = [] {
        didSet {
            print("pages changed:- \(pages)")
        }
    }
    @Published var rulesImp: RuleImp!

    func fetchForm() async {
        do {
            let response = try await formBuildUseCase.excute()
            mode = response.pages.first?.mode
            pages = response.pages
          //  fields = pages.flatMap { $0.fields }
            rules = response.rules
            warnings = response.warnings
            assignWarningsToFields()
           // self.doRules()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func updateTextBoxValue(fieldId: String, newValue: String) {
//        pages = pages.map { page in
//            var updatedPage = page
//            updatedPage.fields = updatedPage.fields.map { field in
//                if case .textBox((let textBoxField, let textBoxViewModel)) = field,
//                   textBoxField.fieldId == fieldId {
//                    textBoxViewModel.control.label = newValue
//                }
//                return field
//            }
//            return updatedPage
//        }
    }

    private func doRules() {
//        let fields: [BaseFieldProtocol] = fields.map { fieldEntity in
//            switch fieldEntity {
//                case .textBox((let field, _)):
//                    return field
//                case .radio((let field, _)):
//                    return field
//                case .page((let field, _)):
//                    return field
//                case .section((let field, _)):
//                    return field
//                case .number((let field,let numberViewModel)):
//                    numberViewModel.numberFieldModel.fieldWarning = warnings
//                    return field
//            }
//        }
      //  rulesImp = RuleImp(controls: fields, rules: rules)
        rulesImp.handleAllRules()
    }

    private func assignWarningsToFields() {
        for pageIndex in pages.indices {
            for fieldIndex in pages[pageIndex].fields.indices {
//                var field = pages[pageIndex].fields[fieldIndex].field
//                field.fieldWarning = warnings
            }
        }
    }

    func applyFieldRules(by id: String) {
        rulesImp.getAffectedRules(forControlId: id)
    }
}
