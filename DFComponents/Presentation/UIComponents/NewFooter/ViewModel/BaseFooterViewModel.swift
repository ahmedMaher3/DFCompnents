//
//  BaseFooterViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import Foundation

final class BaseFooterViewModel: ObservableObject {
     @Published var field: any FieldRenderable

    init(control: any FieldRenderable) {
        self.field = control
    }
}

