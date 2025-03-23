//
//  FooterViewModel.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import Foundation

class FooterViewModel: ObservableObject {
    @Published var footerData: PageFooterEntity
    
    init(footerData: PageFooterEntity) {
        self.footerData = footerData
    }
    
    func toggleExpanded() {
        self.footerData.isExpanded.toggle()
    }
    
}
