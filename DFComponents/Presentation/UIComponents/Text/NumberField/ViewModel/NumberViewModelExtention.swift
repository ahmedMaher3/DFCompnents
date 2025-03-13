//
//  File.swift
//  DFComponents
//
//  Created by Eslam on 12/03/2025.
//
//MARK: - Validate
extension NumberFieldViewModel: ValidateField {
    func updateValidationState(isError: Bool, errorMessage: String?) {
        self.numberFieldModel.isError = isError
        self.numberFieldModel.errorMessage = errorMessage
    }
}
