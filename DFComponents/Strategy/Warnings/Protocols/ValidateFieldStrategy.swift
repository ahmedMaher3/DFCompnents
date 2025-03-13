//
//  ValidateField.swift
//  DFComponents
//
//  Created by Eslam on 12/03/2025.
//
protocol ValidateFieldStrategy {
    func updateValidationState(isError: Bool, errorMessage: String?)
}
