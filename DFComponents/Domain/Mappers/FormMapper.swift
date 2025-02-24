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
    func map (from dto: DTO) -> FieldEntity?
}

class FormMapper: EntityMapper {

    typealias DTO = FieldDTOEnum
    typealias Entity = FieldEntity


    func map(from dto: FieldDTOEnum) -> FieldEntity? {
        switch dto {
        case .textBox(let textBoxField):
            return .textBox(TextBoxViewModel(control: textBoxField))
        case .radio(let radioField):
            return .radio(RadioButtonViewModel(control: radioField))
        }
    }

}

enum FieldEntity: Identifiable {
    case textBox(TextBoxViewModel)
    case radio(RadioButtonViewModel)

    var id: UUID {
        switch self {
        case .textBox(let vm):
            return vm.id
        case .radio(let vm):
            return vm.id
        }
    }
}


