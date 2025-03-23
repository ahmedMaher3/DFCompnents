//
//  PageFooterEntity.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/23/25.
//

import Foundation

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
