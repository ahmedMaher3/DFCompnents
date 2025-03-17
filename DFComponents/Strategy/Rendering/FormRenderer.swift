//
//  FormRenderer.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import SwiftUI

struct FormRenderer<Strategy: RenderStrategy> {
    private let strategy: Strategy

    init(strategy: Strategy) {
        self.strategy = strategy
    }

    func render(fieldEntity: FieldEntity) -> some View {
        return strategy.render(field: fieldEntity)
    }
}
