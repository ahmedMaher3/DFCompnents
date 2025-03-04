//
//  NumberFieldViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation

final class NumberFieldViewModel: ObservableObject {
    //MARK: - NumberBaseProperties
    var numberFieldModel: NumberFieldModel
    init(numberFieldModel: NumberFieldModel) {
        self.numberFieldModel = numberFieldModel
    }
}
