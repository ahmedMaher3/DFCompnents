//
//  PageFooterMapper.swift
//  DFComponents
//
//  Created by Omar Ibrahim on 3/24/25.
//

import Foundation

class PageFooterMapper: OptionalEntityMapper {

    typealias DTO = CampaignItem
    typealias Entity = PageFooterEntity

    func map(from dto: CampaignItem?) -> PageFooterEntity? {
        return PageFooterEntity(
            logo: dto?.logo ?? "",
            title: dto?.title ?? "",
            description: dto?.description ?? "",
            showQuestionsCount: dto?.showQuestionsCount ?? true,
            isExpanded: true
        )
    }
}
