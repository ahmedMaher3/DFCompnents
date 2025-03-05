//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

typealias PageModel = [String: [FieldEntity]]

@MainActor
class FormViewModel: ObservableObject {

    @Published var fields: [FieldEntity] = []
    @Published var pages: PageModel = [:]

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()
    var rules = [Rule]()
    var mode: FormType?
    @Published var rulesImp: RuleImp!

    func fetchForm() async {
        do {
            let response = try await formBuildUseCase.excute()
            self.mode = response.mode
            fields = response.fields
            self.convertToPages()
            rules = response.rules
            self.doRules()
        }
        catch let error as NSError {
            print(error.localizedDescription)
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
            }
        }
        
        rulesImp = RuleImp(controls: fields, rules: rules)
        
        rulesImp.handleAllRules()
    }
    
    func applyFieldRules(by id: String) {
        rulesImp.getAffectedRules(forControlId: id)
    }
    
    private func convertToPages() {
        if let mode = self.mode {
            self.pages = mode == .classic ? convertToPagesInClassicMode() : convertToPagesInCardsMode()
        }
    }
    
    private func convertToPagesInClassicMode() -> PageModel { // in case of pages mode
        var pages: PageModel = [:]

        let pageFields = fields.filter { $0.type == .page }

        for page in pageFields {
            pages[page.id] = []
        }

        for field in fields {
            if let parentId = field.parentId, pages.keys.contains(parentId) {
                pages[parentId]?.append(field)
            }
        }

        return pages
    }
        
    private func convertToPagesInCardsMode() -> PageModel { // in case of cards mode
        var pages: PageModel = [:]
        var cardIndex = 1

        let cardFields = fields.filter { $0.type != .page && $0.type != .section } // all controls except page & sections

        for field in cardFields {
            let pageId = "page_\(cardIndex)" // page id here is set by me ( Will affect rules when working on )

            if pages[pageId] == nil {
                pages[pageId] = []
            }

            pages[pageId]?.append(field)

            cardIndex += 1
        }

        return pages
    }

}
