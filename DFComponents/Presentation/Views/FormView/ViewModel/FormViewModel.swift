//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

@MainActor
class FormViewModel: ObservableObject {

    @Published var fieldsViewModel: [FieldDTOEnum: any ObservableObject] = [:]
    @Published var formFields: [FieldDTOEnum] = []

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()


    func fetchForm() async {
        do {
            formFields =  try await formBuildUseCase.excute()
            let arrayOfDicts = formFields.map { FieldViewModelFactory.make(from: $0) }
            self.fieldsViewModel = arrayOfDicts.reduce([:]) { $0.merging($1) { current, _ in current } }

        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
/*
struct FieldViewModelFactory {
    static func make(from field: FieldDTOEnum) -> [FieldDTOEnum: any ObservableObject] {
        var viewModelsByType: [FieldDTOEnum: any ObservableObject] = [:]
            switch field {
            case .textBox(let textBoxControl):
                let vm = TextBoxViewModel()
                viewModelsByType[field] = vm
            case .radio(let radioControl):
                let vm = RadioButtonViewModel(control: radioControl)
                viewModelsByType[field] = vm
            }
        return viewModelsByType
    }
}
*/

//MARK: - Second Approach
//struct FieldViewModelFactory {
//    static func make(from field: FieldDTOEnum) -> [FieldDTOEnum: any ObservableObject] {
//        var viewModelsByType: [FieldDTOEnum: any ObservableObject] = [:]
//        let controlViewModel = self.createControlViewModel(for: field)
//        if let viewModel = controlViewModel {
//            viewModelsByType[field] = viewModel
//        }
//        return viewModelsByType
//    }
//    static func createControlViewModel(for field: FieldDTOEnum) -> (any ObservableObject)? {
//        switch field {
//            case .textBox(let textBoxControl):
//                return TextBoxViewModel(control: textBoxControl)
//            case .radio(let radioControl):
//                return RadioButtonViewModel(control: radioControl)
//            default:
//                return nil
//        }
//    }
//}

protocol FieldViewModelStrategy {
    func createViewModel(for field: FieldDTOEnum) -> (any ObservableObject)?
}
class TextBoxStrategy: FieldViewModelStrategy {
    func createViewModel(for field: FieldDTOEnum) -> (any ObservableObject)? {
        guard case .textBox(let textBoxControl) = field else { return nil }
        return TextBoxViewModel(control: textBoxControl)
    }
}
class FormBuilderViewModelContext {
    private var strategy: FieldViewModelStrategy

    init(strategy: FieldViewModelStrategy) {
        self.strategy = strategy
    }

    func setStrategy(strategy: FieldViewModelStrategy) {
        self.strategy = strategy
    }

    func createViewModel(for field: FieldDTOEnum) -> (any ObservableObject)? {
        return strategy.createViewModel(for: field)
    }
}

class RadioButtonStrategy: FieldViewModelStrategy {
    func createViewModel(for field: FieldDTOEnum) -> (any ObservableObject)? {
        guard case .radio(let radioControl) = field else { return nil }
        return RadioButtonViewModel(control: radioControl)
    }
}

//struct FieldViewModelFactory {
//    static func make(from field: FieldDTOEnum) -> [FieldDTOEnum: any ObservableObject] {
//        var viewModelsByType: [FieldDTOEnum: any ObservableObject] = [:]
//
//        let strategies: [FieldDTOEnum: FieldViewModelStrategy] = [
//            .textBox: TextBoxStrategy(),
//            .radio: RadioButtonStrategy(),
//
//        ]

//        if let strategy = strategies[field] {
//            let context = FormBuilderViewModelContext(strategy: strategy)
//            if let viewModel = context.createViewModel(for: field) {
//                viewModelsByType[field] = viewModel
//            }
//        }
//
//        return viewModelsByType
//    }
//}
struct FieldViewModelFactory {
    static func make(from field: FieldDTOEnum) -> [FieldDTOEnum: any ObservableObject] {
        var viewModelsByType: [FieldDTOEnum: any ObservableObject] = [:]

        // Define the strategies (you'll instantiate strategies based on the enum case)
        let strategies: [FieldDTOEnum: FieldViewModelStrategy]

        switch field {
        case .textBox(let dto):
            strategies = [
                .textBox(dto): TextBoxStrategy() // Passing TextBoxControlDTO into strategy
            ]
        case .radio(let dto):
            strategies = [
                .radio(dto): RadioButtonStrategy() // Passing RadioControlDTO into strategy
            ]
        }

        if let strategy = strategies[field] {
            let context = FormBuilderViewModelContext(strategy: strategy)
            if let viewModel = context.createViewModel(for: field) {
                viewModelsByType[field] = viewModel
            }
        }

        return viewModelsByType
    }
}
