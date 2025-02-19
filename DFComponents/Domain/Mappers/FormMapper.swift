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
    func map (from dto: DTO) -> ControlType?
}

class FormMapper: EntityMapper {
    typealias DTO = Field
    typealias Entity = ControlType

    func map(from dto: Field) -> Entity? {
        switch dto.type {
        case .DropDown:
            let properties = DropDownProperties(placeholder: dto.properties.placeholder)
            return .dropDown(ControlEntity(id: dto.id ?? "", properties: properties))

        case .TextBox:
            let properties = TextBoxProperties(placeholder: dto.properties.placeholder, maxLength: dto.properties.maxAttachmentsNumber ?? 100)
            return .textBox(ControlEntity(id: dto.id ?? "", properties: properties))

        default:
            return nil
        }


    }


}
