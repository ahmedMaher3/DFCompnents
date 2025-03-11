//
//  HeaderComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class HeaderComponentViewModel: ObservableObject {
    @Published var baseProperties: BaseProperties

    init(baseProperties: BaseProperties) {
        self.baseProperties = baseProperties
    }
}
