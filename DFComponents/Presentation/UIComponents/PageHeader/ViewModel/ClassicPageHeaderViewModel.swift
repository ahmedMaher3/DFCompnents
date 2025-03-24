//
//  ClassicPageHeaderViewModel.swift
//  DFComponents
//
//  Created by Eslam on 24/03/2025.
//

import Foundation

class ClassicPageHeaderViewModel: ObservableObject {
    @Published var headerData: PageHeaderEntity

    init(headerData: PageHeaderEntity) {
        self.headerData = headerData
    }

    func toggleExpanded() {
        headerData.isExpanded.toggle()
    }
}
