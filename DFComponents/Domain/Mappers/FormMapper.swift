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
        let pages = groupFieldsByPage (fields: dto.fields )
//        print("💛\(pages)")
        return pages
    }

//    func groupFieldsByPage(fields: [Field]) -> [PageModel] {
//        let pageIds = fields.compactMap { $0.type == .page ? $0.id : nil }
//        let sectionsIds = fields.compactMap { $0.type == .section ? $0.id : nil }
//
//        let groupedFields = Dictionary(grouping: fields.filter{$0.parentId != nil}) { field in
//            field.parentId.flatMap { pageIds.contains($0) ? $0 : nil }
//        }
//       // let pages = groupedFields.map { PageModel(id: $0.key!, fields: mapFields(fields: $0.value)) }
//        let pages = groupedFields.map { (key, value) in
//            let mappedFields = mapFields(fields: value)
//            // 🔹 Debug: Print the mapping process
//            print("Mapping for Page ID:", key ?? "Unknown", "Mapped Fields:", mappedFields)
//
//            return PageModel(id: key ?? "", fields: mappedFields)
//        }
//
//        return pages
//    }

    func groupFieldsByPage(fields: [Field]) -> [PageModel] {
        let pageIds = Set(fields.compactMap { $0.type == .page ? $0.id : nil }) // Store valid Page IDs
        let sectionIds = Set(fields.compactMap { $0.type == .section ? $0.id : nil }) // Store valid Section IDs

        let groupedByPage = Dictionary(grouping: fields.filter { $0.parentId != nil }) { field in
            field.parentId.flatMap { pageIds.contains($0) ? $0 : nil }
        }

        let pages = groupedByPage.map { (pageId, pageFields) in
            let groupedBySection = Dictionary(grouping: pageFields) { field in
                field.parentId.flatMap { sectionIds.contains($0) ? $0 : nil }
            }

            let mappedFields = mapFields(fields: pageFields, groupedBySection: groupedBySection)

            print("Mapping for Page ID:", pageId ?? "Unknown", "Mapped Fields:", mappedFields) // Debugging

            return PageModel(id: pageId ?? "", fields: mappedFields)
        }

        return pages
    }


    func mapFields(fields: [Field], groupedBySection: [String?: [Field]]) -> [FieldEntity] {
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

            case .section:
                let control = SectionField(field: field)
                let sectionFields = groupedBySection[field.id] ?? [] // Get fields for this section
                let sectionControls = mapFields(fields: sectionFields, groupedBySection: groupedBySection)
                return .section((control, SectionViewModel(controls: sectionControls, title: "Section Title")))

            case .number:
                let control = TextBoxField(field: field)
                return .textBox((control, TextBoxViewModel(control: control)))

            default:
                return nil
            }
        }
    }

//    func mapFields(fields: [Field]) -> [FieldEntity] {
//        return fields.compactMap { field in
//            switch field.type {
//            case .textBox:
//                let control = TextBoxField(field: field)
//                return .textBox((control, TextBoxViewModel(control: control)))
//            case .radio:
//                let control = RadioButtonField(field: field)
//                return .radio((control, RadioButtonViewModel(control: control)))
//            case .page:
//                let control = PageField(field: field)
//                return .page((control, PageViewModel()))
//            case .section:
//                let control = SectionField(field: field)
//                return .section((control, SectionViewModel(controls: [], title: "title")))
//            case .number:
//                let control = TextBoxField(field: field)
//                return .textBox((control, TextBoxViewModel(control: control)))
//
//            default:
//                return nil
//            }
//        }
//    }
    
}

struct PageModel: Identifiable {
    var id: String
    var fields: [FieldEntity]
}
//struct Section: Identifiable {
//    var id: String
//    var fields: [FieldEntity]
//}


enum FieldEntity: Identifiable {
    case textBox((BaseFieldProtocol, TextBoxViewModel))
    case radio((BaseFieldProtocol, RadioButtonViewModel))
    case page((BaseFieldProtocol, PageViewModel))
    case section((BaseFieldProtocol, SectionViewModel))
    
    var id: String {
        switch self {
        case .page((let field, _)):
            return field.fieldId
        case .textBox((let field, _)):
            return field.fieldId
        case .radio((let field, _)):
            return field.fieldId
        case .section((let field, _)):
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
        case .section((let field, _)):
            return field.parentId
        }
    }
    
    var type: FieldType {
        switch self {
        case .textBox((let field, _)), .radio((let field, _)), .page((let field, _)), .section((let field, _)):
            return field.type
        }
    }

}

