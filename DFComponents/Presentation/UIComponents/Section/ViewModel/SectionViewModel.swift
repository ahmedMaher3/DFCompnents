//
//  SectionViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class SectionViewModel: ObservableObject,BaseViewModel {
    @Published var sectionField: SectionField
    @Published var controls: [any FieldRenderable]

    init(controls: [any FieldRenderable], sectionField: SectionField) {
        self.controls = controls
        self.sectionField = sectionField
    }
}
