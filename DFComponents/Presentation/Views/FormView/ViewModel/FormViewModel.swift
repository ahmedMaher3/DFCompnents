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
    
//    private func convertToPages() {
//        if let mode = self.mode {
//            self.pages = mode == .classic ? convertToPagesInClassicMode() : convertToPagesInCardsMode()
//        }
//    }
//            
//    private func convertToPagesInCardsMode() -> PageModel { // in case of cards mode
//        var pages: PageModel = [:]
//        var cardIndex = 1
//
//        let cardFields = fields.filter { $0.type != .page && $0.type != .section } // all controls except page & sections
//
//        for field in cardFields {
//            let pageId = "page_\(cardIndex)" // page id here is set by me ( Will affect rules when working on )
//
//            if pages[pageId] == nil {
//                pages[pageId] = []
//            }
//
//            pages[pageId]?.append(field)
//
//            cardIndex += 1
//        }
//
//        return pages
//    }
//        
//    private func convertToPagesInClassicMode() -> PageModel {
//        var pages: PageModel = [:]
//        var sections: [String: [FieldEntity]] = [:]
//
//        // Step 1: Initialize pages dictionary with page-type fields
//        for field in fields where field.type == .page {
//            pages[field.id] = []
//        }
//        
//        // Step 2: Distribute fields into sections and pages
//        distributeFieldsIntoSectionsAndPages(fields: fields, sections: &sections, pages: &pages)
//
//        // Step 3: Convert section entities to `FieldEntity.section` and insert into their parent pages
//        processSections(sections: sections, fields: fields, pages: &pages)
//        
//        return pages
//    }
//    
//    private func distributeFieldsIntoSectionsAndPages(fields: [FieldEntity], sections: inout PageModel, pages: inout PageModel) {
//        for field in fields where field.type != .page {
//            guard let parentId = field.parentId else { continue }
//
//            if field.type == .section {
//                sections[field.id] = [] // Initialize empty section
//            } else if sections[parentId] != nil {
//                sections[parentId]?.append(field) // Add field to section
//            } else if pages[parentId] != nil {
//                pages[parentId]?.append(field) // Add field to page
//            }
//        }
//    }
//    
//    private func processSections(sections: PageModel, fields: [FieldEntity], pages: inout PageModel) {
//        for (sectionId, sectionFields) in sections {
//            if let fieldEntity = fields.first(where: { $0.id == sectionId }) {
//                let sectionEntity = convertEntityToBaseFieldProtocol(fieldEntity)
//                let sectionViewModel = SectionViewModel(controls: sectionFields, title: "sectionEntity.label")
//                let sectionFieldEntity: FieldEntity = .section((sectionEntity, sectionViewModel)) // sectionEntity doesn't conform BaseFieldProtocol
//
//                if let parentPageId = sectionEntity.parentId, pages[parentPageId] != nil {
//                    pages[parentPageId]?.append(sectionFieldEntity)
//                }
//            }
//        }
//    }
//    
//    private func convertEntityToBaseFieldProtocol(_ entity: FieldEntity) -> BaseFieldProtocol {
//        let baseField: BaseFieldProtocol
//        switch entity {
//        case .textBox(let (control, _)),
//                .radio(let (control, _)),
//                .page(let (control, _)),
//                .section(let (control, _)):
//            baseField = control
//        }
//        return baseField
//    }


    func checkingWarning(for fieldId: String, value: Any?, isError: Bool) {
        guard let warnings else { return }
        var fieldWarnings: [String] = []

        if checkValueIsEmpty(value: value),
           let requiredWarning = warnings.fieldValidation.required {
            fieldWarnings.append(requiredWarning)
        }

        if let field = fields.first(where: { $0.id == fieldId }) {
            switch field {
                case .textBox((let baseField, _)),
                        .radio((let baseField, _)),
                        .number((let baseField, _)),
                        .page((let baseField, _)),
                        .section((let baseField, _)):
                    if let numericWarning = warnings.fieldValidation.input.numeric, isError {
                        fieldWarnings.append(numericWarning)
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
