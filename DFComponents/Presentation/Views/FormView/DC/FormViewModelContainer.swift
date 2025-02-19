//
//  FormViewModelContainer.swift
//  DFComponents
//
//  Created by Eslam on 19/02/2025.
//
import SwiftUI

class FormViewModelContainer {
    private var viewModels: [String: (Field) -> any ObservableObject] = [:]

    func registerViewModel<T: ObservableObject>(_ fieldType: String, factory: @escaping (Field) -> T) {
        viewModels[fieldType] = { field in
            return factory(field)
        }
    }

    func resolve(for fieldType: String, field: Field) -> (any ObservableObject)? {
        if let viewModel = viewModels[fieldType] {
            return viewModel(field)
        }
        return nil
    }
}
