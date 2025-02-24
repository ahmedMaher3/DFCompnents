//
//  FormEntity.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/24/25.
//


struct FormEntity {
    var items = [FormViewModelItemProtocol]()
    var rules: [Rule]?
//    var warnings: Warning?
    
    init(_ form: Schema) {
        for field in form.fields {
            switch field.type {
            case .TextBox:
                let item = FormViewModelTextBoxItem(field: field)
                items.append(item)
            case .Radio:
                let item = RadioButtonItem(field: field)
                items.append(item)
            // ... handle other cases similarly
            default:
                break
            }
        }
        self.rules = form.rules
//        self.warnings = form.warnings
    }
    
    mutating func appendSubmitItem() {
//        let item = FormViewModelItem(field: nil)
//        items.append(item)
    }
    
    // Helper methods for managing form items
    func getItem(by id: String) -> FormViewModelItemProtocol? {
        return items.first { $0.fieldId == id }
    }
    
    mutating func updateItem(_ item: FormViewModelItemProtocol?) {
        guard let item else { return }
        guard let index = items.firstIndex(where: { $0.fieldId == item.fieldId }) else { return }
        updateItem(at: index, with: item)
    }
    
    mutating func updateItem(at index: Int, with item: FormViewModelItemProtocol) {
        guard index < items.count else { return }
        items[index] = item
    }
    
    func validateAll() -> Bool {
        return items.allSatisfy { item in
            // Add your validation logic here
            guard let interactive = item as? InteractiveItemProtocol else { return true }
            return !interactive.required || interactive.isAnswered()
        }
    }
}

extension FormEntity {
    // Helper method to get typed items
    func getTextBoxItem(by id: String) -> FormViewModelTextBoxItem? {
        return getItem(by: id) as? FormViewModelTextBoxItem
    }
    
    // Add more helper methods for other types
//    func getDropdownItem(by id: String) -> FormViewModelDropdownItem? {
//        return getItem(by: id) as? FormViewModelDropdownItem
//    }
}

extension FormEntity {
    mutating func updateAnswer(for id: String, with answer: Any) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].answer = answer
            print("Display the answer please!!!:\(items[index].answer)")
        }
    }
    
    func getAnswerString(for id: String) -> String? {
        return getItem(by: id)?.getAnswerString()
    }
    
    mutating func hideField(_ id: String) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].hidden = true
        }
    }
    
    mutating func showField(_ id: String) {
        if let index = items.firstIndex(where: { $0.fieldId == id }) {
            items[index].hidden = false
        }
    }
}
