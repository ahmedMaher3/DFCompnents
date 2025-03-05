//
//  FormMapper.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol EntityMapper {
    associatedtype DTO
    associatedtype Entity
    func map (from dto: DTO) -> [FieldEntity]
}

class FormMapper: EntityMapper {
    
    typealias DTO = Schema
    typealias Entity = FieldEntity
    
    func map(from dto: Schema) -> [FieldEntity] {
        return dto.fields.compactMap { field in
            switch field.type {
            case .textBox:
                let control = TextBoxField(field: field)
                return .textBox((control, TextBoxViewModel(control: control)))
            case .radio:
                let control = RadioButtonField(field: field)
                return .radio((control, RadioButtonViewModel(control: control)))
            case .page:
                let control = PageField()
                return .page((control, PageViewModel()))

            default:
                return nil
            }
        }
    }
}

//struct Form {
//    var items: [FieldEntity]
//    var rules: [Rule]
//}

enum FieldEntity: Identifiable {
    case textBox((BaseFieldProtocol, TextBoxViewModel))
    case radio((BaseFieldProtocol, RadioButtonViewModel))
    case page((BaseFieldProtocol, PageViewModel))
    
    var id: String {
        switch self {
        case .page((let field, _)):
            return field.fieldId
        case .textBox((let field, _)):
            return field.fieldId
        case .radio((let field, _)):
            return field.fieldId
        }
    }
    
    var parentId: String? {
        switch self {
        case .textBox((let field, _)):
            return field.parentId
        case .radio((let field, _)):
            return field.parentId
        case .page((let field, _)):
            return field.parentId
        }
    }
    
    var type: FieldType {
        switch self {
        case .textBox((let field, _)), .radio((let field, _)), .page((let field, _)):
            return field.type
        }
    }

}
