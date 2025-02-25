//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

final class RadioButtonViewModel: FieldViewModelProtocol {

    @Published var control: RadioButtonField

     init(control: RadioButtonField) {
         self.control = control
     }

     // When an option is selected, update all options:
     func selectOption(_ option: MCQOption) {
         control.options =  control.options.map{var item = $0; item.isSelected = false; return item }

         if let index = control.options.firstIndex(where: {$0.id == option.id}) {
             control.options[index].isSelected = true
             control.answer = option.id
         }
     }

}

