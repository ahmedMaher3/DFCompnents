//
//  SliderViewModel.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/3/25.
//

import SwiftUI

class SliderViewModel: ObservableObject {
    @Published var value: Double = 0
    
    let field: SliderDTO
    
    init() {
        field = .init(title: "Slider", representation: .single, minimumValue: 0, maximumValue: 100, step: 1, value: 0)
    }
}
