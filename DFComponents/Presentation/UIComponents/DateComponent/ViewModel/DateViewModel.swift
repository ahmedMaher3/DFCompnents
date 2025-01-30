//
//  DateViewModel.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/29/25.
//

import SwiftUI

class DateFieldViewModel: ObservableObject {
    @Published var dateValue: Date = .now
    var formattedValue: String {
        let format = getFormat()
        return dateValue.formatted(date: format.date, time: format.time)
    }

    let field: DateDTO

    init() {
        field = .init(title: "Date", representation: .date, value: .now)
    }
    
    func getFormat() -> (date: Date.FormatStyle.DateStyle, time: Date.FormatStyle.TimeStyle) {
        if field.representation == .date {
            return (.long, .omitted)
        } else if field.representation == .dateTime {
            return (.long, .standard)
        } else if field.representation == .time {
            return (.omitted, .shortened)
        } else {
            return (.omitted, .omitted)
        }
    }
    
    var displayedComponents: DatePickerComponents {
        switch field.representation {
            case .date:
            return [.date]
        case .dateTime:
            return [.date, .hourAndMinute]
        case .time:
            return [.hourAndMinute]
        }
    }
}
