//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

enum FormState {
    case loading
    case loaded
    case error
}

@MainActor
class FormViewModel: ObservableObject {

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()
    var rules = [Rule]()
    var warnings: WarningsEntity?

    @Published var state: FormState = .loading
    @Published var mode: FormType?
    @Published var fields: [FieldEntity] = []
    @Published var pages: [PageEntity] = []
    @Published var rulesImp: RuleImp!
    @Published var header: CampaignItem?
    @Published var footer: CampaignItem?
    @Published var welcomeData: CampaignItem?

        func fetchForm() async {
            state = .loading
            do {
                let response = try await formBuildUseCase.excute()
                mode = response.pages.first?.mode
                welcomeData = response.welcome
                header = response.header
                footer = response.footer
                pages = response.pages
                fields = pages.flatMap { $0.fields }
                rules = response.rules
                warnings = response.warnings
                handleRules()
                state = .loaded
            } catch {
                state = .error
            }
        }


    private func handleRules() {
        let fields: [BaseFieldProtocol] = fields.map { fieldEntity in
            switch fieldEntity {
            case .textBox(let field, _):
                    return field
            case .radio(let field, _):
                    return field
            case .page(let field, _):
                    return field
            case .section(let field, _):
                    return field
            case .number(let field,let numberViewModel):
                    numberViewModel.numberFieldModel.fieldWarning = warnings
                    return field
            }
        }
        rulesImp = RuleImp(controls: fields, rules: rules)
        rulesImp.handleAllRules()
    }

    func applyFieldRules(by id: String) {
        rulesImp.getAffectedRules(forControlId: id)
    }
}

