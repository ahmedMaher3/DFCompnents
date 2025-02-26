//
//  RadioButtonViewModel.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import Foundation

final class RadioButtonViewModel: ObservableObject {

    @Published var control: RadioButtonField
    let id: String

     init(control: RadioButtonField) {
         self.control = control
         self.id = "2"
//         $control
//                   .map { $0.options }
//                   .removeDuplicates()
//                   .sink { [weak self] updatedOptions in
//                       print("Options changed in ViewModel: \(updatedOptions)")
//                      // self?.notifyParent()
//                   }
//                  // .store(in: &cancellables)
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
