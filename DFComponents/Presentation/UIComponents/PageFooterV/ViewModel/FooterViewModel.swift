//
//  FooterViewModel.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import Foundation

class FooterViewModel: ObservableObject {
    @Published var footerEntity: PageHeaderFooterEntity
    
    init(footerEntity: PageHeaderFooterEntity) {
        self.footerEntity = footerEntity
    }
    
    func toggleExpanded() {
        self.footerEntity.isExpanded.toggle()
    }
    
}
