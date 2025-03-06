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
    func map (from dto: DTO) -> [PageModel]
}

class FormMapper: EntityMapper {
    
    typealias DTO = Schema
    typealias Entity = FieldEntity
    
    func map(from dto: Schema) -> [PageModel] {
        let pages = groupFieldsByPage (fields: dto.fields,mode:dto.settings.format )
        return pages
    }

    func groupFieldsByPage(fields: [Field], mode: FormType) -> [PageModel] {
        let pageIds = fields.compactMap { $0.type == .page ? $0.id : nil }

        let groupedFields = Dictionary(grouping: fields.filter{$0.parentId != nil}) { field in

            field.parentId.flatMap { pageIds.contains($0) ? $0 : nil }
        }
        //let pages = groupedFields.map { PageModel(id: $0.key!, fields: mapFields(fields: $0.value)) }
        let pages = groupedFields.map { (key, value) in
            let mappedFields = mapFields(fields: value)

            // 🔹 Debug: Print the mapping process
            print("Mapping for Page ID:", key ?? "Unknown", "Mapped Fields:", mappedFields)

            return PageModel(id: key ?? "", fields: mappedFields, mode: mode)
        }

        return pages
    }

    


    func mapFields(fields: [Field]) -> [FieldEntity] {
        return fields.compactMap { field in
            switch field.type {
            case .textBox:
                let control = TextBoxField(field: field)
                return .textBox((control, TextBoxViewModel(control: control)))
            case .radio:
                let control = RadioButtonField(field: field)
                return .radio((control, RadioButtonViewModel(control: control)))
            case .page:
                let control = PageField(field: field)
                return .page((control, PageViewModel()))
            case .number:
                let control = TextBoxField(field: field)
                return .textBox((control, TextBoxViewModel(control: control)))

            default:
                return nil
            }
        }
    }
    
}

struct PageModel: Identifiable {
    var id: String
    var fields: [FieldEntity]
    var mode: FormType
}

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
