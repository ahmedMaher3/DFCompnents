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

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()
    var rules = [Rule]()
    @Published var rulesImp: RuleImp!

    func fetchForm() async {
        do {
            let response =  try await formBuildUseCase.excute()
           fields = response.fields
            rules = response.rules
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
            }
        }
        
        rulesImp = RuleImp(controls: fields, rules: rules)
        
        rulesImp.handleAllRules()
    }
    
    func applyFieldRules(by id: String) {
        
        rulesImp.getAffectedRules(forControlId: id)
    }
}
