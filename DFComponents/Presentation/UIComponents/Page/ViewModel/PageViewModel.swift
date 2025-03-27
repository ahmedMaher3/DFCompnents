//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
    @Published var controls: [FieldEntity]
    @Published var showFooter: Bool
    @Published var pageFooter: PageHeaderFooterEntity
    @Published var pageField: PageField
    
    init(controls: [FieldEntity], showFooter: Bool, pageFooter: PageHeaderFooterEntity, pageField: PageField) {
//        init(controls: [FieldEntity], pageField: PageField) {
//        self.pageField = pageField

        self.controls = controls
        self.showFooter = showFooter
        self.pageFooter = pageFooter
        self.pageField = pageField
    }
}
