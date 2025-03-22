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

struct PageFooterEntity {
    let logo: String
    let title: String
    let description: String
    let showQuestionsCount: Bool
    var isExpanded: Bool
    
    init(classicPageFooter: ClassicPageFooter) {
        self.logo = classicPageFooter.logo ?? ""
        self.title = classicPageFooter.title ?? ""
        self.description = classicPageFooter.description ?? ""
        self.showQuestionsCount = classicPageFooter.showQuestionsCount ?? false
        self.isExpanded = true
    }
}
