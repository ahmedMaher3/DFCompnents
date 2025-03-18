//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var pageField: PageField
    @Published var controls: [FieldRenderable]
    
//    init(controls: [FieldRenderable], pageFieldProperties: PageProperties) {
    init(controls: [FieldRenderable], pageField: PageField) {
//        self.pageFieldProperties = pageFieldProperties
        self.pageField = pageField
        self.controls = controls
    }
}
