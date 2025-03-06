//
//  SectionViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class SectionViewModel: ObservableObject {
    @Published var controls: [FieldEntity]
    let title: String
    let id: String

    init(controls: [FieldEntity], title: String) {
        self.controls = controls
        self.id = "2"
        self.title = title
    }
}
