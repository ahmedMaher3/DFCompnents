//
//  PageViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

final class PageViewModel: ObservableObject {
//    @Published var pageField: PageField
    @Published var controls: [FieldEntity]
    @Published var showFooter: Bool
    @Published var showHeader: Bool
    @Published var pageFooter: PageFooterEntity
    
    init(controls: [FieldEntity],showHeader: Bool, showFooter: Bool, pageFooter: PageFooterEntity) {
//        init(controls: [FieldEntity], pageField: PageField) {
//        self.pageField = pageField
        self.controls = controls
        self.showHeader = showHeader
        self.showFooter = showFooter
        self.pageFooter = pageFooter
    }
}
