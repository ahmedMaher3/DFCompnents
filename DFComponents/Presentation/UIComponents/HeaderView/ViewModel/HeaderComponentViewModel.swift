//
//  HeaderComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation
//final class HeaderComponentViewModel: ObservableObject {
//    private var baseProperties : BasePropertiesProtocol
//    init(baseProperties: BasePropertiesProtocol) {
//        self.baseProperties = baseProperties
//    }
//}
final class HeaderComponentViewModel<T: BasePropertiesProtocol>: ObservableObject {
    @Published var baseProperties: T

    init(baseProperties: T) {
        self.baseProperties = baseProperties
    }
}
