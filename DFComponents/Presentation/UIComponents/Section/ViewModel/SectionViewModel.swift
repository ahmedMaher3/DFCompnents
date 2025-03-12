//
//  SectionViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class SectionViewModel: ObservableObject {
    @Published var sectionField: SectionField
    @Published var controls: [FieldEntity] {
        didSet {
            print("controls changed:- \(controls) ")
        }
    }

    init(controls: [FieldEntity], sectionField: SectionField) {
        self.controls = controls
        self.sectionField = sectionField
    }
}
