//
//  FormViewModelStrategy.swift
//  DFComponents
//
//  Created by Eslam on 24/02/2025.
//

import Foundation

@MainActor
protocol FormViewModelStrategy {
    func process(viewModel: any ObservableObject, key: String, formBuilder: FormViewModel)
}

