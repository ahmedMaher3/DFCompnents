//
//  PageHeaderMapper.swift
//  DFComponents
//
//  Created by Eslam on 24/03/2025.
//

import Foundation

class PageHeaderMapper: OptionalEntityMapper {

    typealias DTO = CampaignItem
    typealias Entity = PageHeaderEntity

    func map(from dto: CampaignItem?) -> PageHeaderEntity? {
        return PageHeaderEntity(
            logo: dto?.logo ?? "",
            title: dto?.title ?? "",
            description: dto?.description ?? "",
            showQuestionsCount: dto?.showQuestionsCount ?? true,
            isExpanded: true
        )
    }
}
