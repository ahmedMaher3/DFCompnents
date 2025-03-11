//
//  HeaderComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class HeaderComponentViewModel: ObservableObject {
    @Published var field: FieldEntity

    init(fieldEntity: FieldEntity) {
        self.field = fieldEntity
    }
}
