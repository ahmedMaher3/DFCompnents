//
//  SectionViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class SectionViewModel: ObservableObject {
    @Published var sectionField: SectionField
    @Published var control: SectionField
    @Published var controls: [FieldEntity]

    init(control: SectionField, controls: [FieldEntity], sectionField: SectionField) {
        self.control = control
        self.controls = controls
        self.sectionField = sectionField
    }
}
