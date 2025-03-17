//
//  FormComponent.swift
//  DFComponents
//
//  Created by Eslam on 16/03/2025.
//
import SwiftUI

protocol FormComponent: Identifiable {
    var id: String { get } /// Unique identifier for each form element
    associatedtype Content: View
    @ViewBuilder func render() -> Content
}
