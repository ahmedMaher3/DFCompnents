//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var controls: [FieldRenderable]

    init(controls: [FieldRenderable]) {
        self.controls = controls
    }
}
