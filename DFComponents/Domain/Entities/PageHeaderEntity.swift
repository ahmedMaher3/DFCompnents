//
//  PageHeaderEntity.swift
//  DFComponents
//
//  Created by Eslam on 24/03/2025.
//

import Foundation

struct PageHeaderEntity {
    let logo: String
    let title: String
    let description: String
    let showQuestionsCount: Bool
    var isExpanded: Bool

    init(classicPageFooter: CampaignItem) {
        self.logo = classicPageFooter.logo ?? ""
        self.title = classicPageFooter.title ?? ""
        self.description = classicPageFooter.description ?? ""
        self.showQuestionsCount = classicPageFooter.showQuestionsCount ?? false
        self.isExpanded = true
    }
}
