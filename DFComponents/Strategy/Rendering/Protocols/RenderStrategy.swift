//
//  RenderStrategy.swift
//  DFComponents
//
//  Created by Eslam on 17/03/2025.
//
import SwiftUI

protocol RenderStrategy {
    associatedtype Content: View
    @ViewBuilder func render(field: FieldEntity) -> Content
}
