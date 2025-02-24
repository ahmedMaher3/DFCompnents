//
//  FormViewModel.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

protocol FieldViewModelProtocol: ObservableObject, Identifiable {

}

extension FieldViewModelProtocol {
    var id: UUID { UUID() }  // or require each conforming type to provide its own unique ID
}

@MainActor
class FormViewModel: ObservableObject {

    @Published var fields: [ FieldEntity] = []

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()

    func fetchForm() async {
        do {
            fields =  try await formBuildUseCase.excute()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


