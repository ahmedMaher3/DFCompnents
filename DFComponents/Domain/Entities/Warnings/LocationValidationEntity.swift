//
//  LocationValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct LocationValidationEntity {
    let maximumLocations: String
    let minimumLocations: String
    let notInRange: String
}
extension LocationValidationEntity {
    init(from dto: LocationValidation) {
        self.init(
            maximumLocations: dto.maximumLocations,
            minimumLocations: dto.minimumLocations,
            notInRange: dto.notInRange
        )
    }
}
