//
//  GeneralValidationStrategyProtocol.swift
//  DFComponents
//
//  Created by Eslam on 11/03/2025.
//
//MARK: - GeneralValidationStrategy for common validations (EntryLimit , ValueLimit) for any control
protocol GeneralValidationStrategyProtocol {
    func validate(
        value: String?,
        fieldWarning: inout String
    )
}

