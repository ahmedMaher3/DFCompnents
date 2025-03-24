//
//  PageFooterMapper.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/24/25.
//

import Foundation

class PageHeaderFooterMapper: OptionalEntityMapper {

    typealias DTO = CampaignItem
    typealias Entity = PageHeaderFooterEntity

    func map(from dto: CampaignItem?) -> PageHeaderFooterEntity? {
        return PageHeaderFooterEntity(
            logo: dto?.logo ?? "",
            title: dto?.title ?? "",
            description: dto?.description ?? "",
            showQuestionsCount: dto?.showQuestionsCount ?? true,
            isExpanded: true
        )
    }
}
