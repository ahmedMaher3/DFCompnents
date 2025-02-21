//
//  FormViewModelContainer.swift
//  DFComponents
//
//  Created by Eslam on 19/02/2025.
//
import SwiftUI
//
class FormViewModelContainer {
    private var viewModels: [AnyHashable: (FormEntity) -> any ObservableObject] = [:]

    // Register view model with a generic key type
    func registerViewModel<T: ObservableObject, Key: Hashable>(_ fieldControl: Key, factory: @escaping (FormEntity) -> T) {
        viewModels[fieldControl] = { field in
            return factory(field)
        }
    }

    // Resolve view model using a generic key type
    func resolve<Key: Hashable>(for control: Key, field: FormEntity) -> (any ObservableObject)? {
        if let viewModel = viewModels[control] {
            return viewModel(field)
        }
        return nil
    }
}


