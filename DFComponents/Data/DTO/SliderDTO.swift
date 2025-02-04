//
//  SliderDTO.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/3/25.
//

import Foundation

struct SliderDTO: Identifiable {
    var id = UUID()
    var title: String
    var representation: SliderRepresentation
    var minimumValue: Double
    var maximumValue: Double
    var step: Double
    var value: Double
    
    enum SliderRepresentation {
        case single
        case range
    }
}
