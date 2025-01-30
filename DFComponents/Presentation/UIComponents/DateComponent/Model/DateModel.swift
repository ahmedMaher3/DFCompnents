//
//  DateModel.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/29/25.
//

import Foundation

struct DateField: Identifiable {
    var id = UUID()
    var title: String
    var representation: DateRepresentation
    var value: Date

    enum DateRepresentation {
        case date
        case dateTime
        case time
    }
}
