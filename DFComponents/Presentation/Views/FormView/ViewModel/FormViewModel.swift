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
    var id: UUID { UUID() }  
}

@MainActor
class FormViewModel: ObservableObject {

    @Published var fields: [ FieldEntity] = []

    var formBuildUseCase: FormBuildUseCase = FormBuildUseCase()

    func fetchForm() async {
        do {
            let response =  try await formBuildUseCase.excute()
            fields = response.fields
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


