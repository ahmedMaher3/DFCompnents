//
//  FormViewModelImplementationStrategy.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//

import Foundation

@MainActor
class ViewModelProcessor {
    private var strategies: [String: FormViewModelStrategy]

    init() {
        strategies = [
            String(describing: TextBoxViewModel.self): TextBoxViewModelStrategy()
        ]
    }

    func process(viewModels: [String: any ObservableObject], formBuilder: FormViewModel) {
        viewModels.forEach { key, viewModel in
            // Find the strategy based on the type of the viewModel
            if let strategy = strategies[String(describing: type(of: viewModel))] {
                strategy.process(viewModel: viewModel, key: key, formBuilder: formBuilder)
            } else {
                print("No strategy found for viewModel type \(type(of: viewModel))")
            }
        }
    }
}
