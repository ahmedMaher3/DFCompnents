//
//  DateTimeValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct DateTimeValidationEntity {
    let dateTime: String
    let dateRange: String
}

extension DateTimeValidationEntity {
    init(from dto: DateTimeValidation) {
        self.init(
            dateTime: dto.dateTime,
            dateRange: dto.dateRange
        )
    }
}
