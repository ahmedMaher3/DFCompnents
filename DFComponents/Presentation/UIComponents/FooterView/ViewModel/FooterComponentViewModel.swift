//
//  FooterComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class FooterComponentViewModel: ObservableObject {
    @Published var field: FieldEntity

    init(control: FieldEntity) {
        self.field = control
    }
}
