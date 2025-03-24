//
//  ClassicPageHeaderViewModel.swift
//  DFComponents
//
//  Created by Eslam on 24/03/2025.
//

import Foundation

class ClassicPageHeaderViewModel: ObservableObject {
    @Published var headerData: PageHeaderFooterEntity

    init(headerData: PageHeaderFooterEntity) {
        self.headerData = headerData
    }

    func toggleExpanded() {
        headerData.isExpanded.toggle()
    }
}
