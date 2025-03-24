//
//  FooterViewModel.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import Foundation

class FooterViewModel: ObservableObject {
    @Published var footerEntity: PageFooterEntity
    
    init(footerEntity: PageFooterEntity) {
        self.footerEntity = footerEntity
    }
    
    func toggleExpanded() {
        self.footerEntity.isExpanded.toggle()
    }
    
}
