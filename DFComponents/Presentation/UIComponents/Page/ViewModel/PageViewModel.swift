//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var pageField: PageField
    @Published var controls: [any FieldRenderable]
    
    init(controls: [any FieldRenderable], pageField: PageField) {
        self.pageField = pageField
        self.controls = controls
    }
}
