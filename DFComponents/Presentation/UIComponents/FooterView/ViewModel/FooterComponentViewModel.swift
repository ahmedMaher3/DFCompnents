//
//  FooterComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class FooterComponentViewModel: ObservableObject {
    @Published var interactiveProperties: InteractiveField
    @Published var fieldEntity: FieldEntity

    init( fieldEntity: FieldEntity,interactiveProperties: InteractiveField) {
        self.fieldEntity = fieldEntity
        self.interactiveProperties = interactiveProperties
    }
}
