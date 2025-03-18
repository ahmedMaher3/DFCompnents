//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var controls: [any FieldRenderable]

    init(controls: [any FieldRenderable]) {
        self.controls = controls
    }
}
