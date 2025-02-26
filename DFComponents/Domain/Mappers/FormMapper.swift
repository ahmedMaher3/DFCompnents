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
            case .TextBox:
                let control = TextBoxField(field: field)
                return .textBox((control, TextBoxViewModel(control: control)))
            case .Radio:
                let control = RadioButtonField(field: field)
                return .radio((control, RadioButtonViewModel(control: control)))

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

    var id: String {
        switch self {
        case .textBox(( let field, let vm)):
            return field.fieldId
        case .radio(( let field, let vm)):
            return field.fieldId
        }
    }
}


