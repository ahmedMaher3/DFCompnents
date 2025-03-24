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

    init(classicPageHeader: CampaignItem) {
        self.logo = classicPageHeader.logo ?? ""
        self.title = classicPageHeader.title ?? ""
        self.description = classicPageHeader.description ?? ""
        self.showQuestionsCount = classicPageHeader.showQuestionsCount ?? false
        self.isExpanded = true
    }
}
