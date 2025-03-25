//
//  FieldEntity.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

enum FieldEntity: Identifiable {
    case textBox(BaseFieldProtocol, TextBoxViewModel)
    case radio(BaseFieldProtocol, RadioButtonViewModel)
    case page(BaseFieldProtocol, PageViewModel)
    case section(BaseFieldProtocol, SectionViewModel)
    case number(BaseFieldProtocol, NumberFieldViewModel)

    var baseField: BaseFieldProtocol {
        switch self {
        case .textBox(let field, _),
             .radio(let field, _),
             .page(let field, _),
             .section(let field, _),
             .number(let field, _):
            return field
        }
    }

    var id: String { baseField.fieldId }
    var parentId: String? { baseField.parentId }
    var type: FieldType { baseField.type }
    var errorMessage: String? { baseField.errorMessage }
    var label: String { baseField.label ?? "" }

    var value: String? {
        get { baseField.answer as? String }
        set {
            guard let newValue = newValue else { return }
            switch self {
            case .textBox(var field, let viewModel):
                field.answer = newValue
                self = .textBox(field, viewModel)
            case .radio(var field, let viewModel):
                field.answer = newValue
                self = .radio(field, viewModel)
            case .page(var field, let viewModel):
                field.answer = newValue
                self = .page(field, viewModel)
            case .section(var field, let viewModel):
                field.answer = newValue
                self = .section(field, viewModel)
            case .number(var field, let viewModel):
                field.answer = newValue
                self = .number(field, viewModel)
            }
        }
    }



    var validatorField: FieldValidationStrategy? {
        if case .number = self {
            return NumberValidationStrategy()
        }
        return nil
    }

    var validateViewModel: ValidateFieldStrategy? {
        switch self {
        case .number(_, let viewModel):
            return viewModel
        default:
            return nil
        }
    }
}
