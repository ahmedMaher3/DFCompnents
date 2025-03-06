//
//  FooterComponentViewModel.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import Foundation
/*
 final class FooterComponentViewModel: ObservableObject {
 private var interactiveBaseProperties: InteractivePropertiesProtocol
 init(interactiveBaseProperties: InteractivePropertiesProtocol) {
 self.interactiveBaseProperties = interactiveBaseProperties
 }
 }
 */
//final class FooterComponentViewModel<T: InteractivePropertiesProtocol>: ObservableObject {
//    @Published var interactiveBaseProperties: T
//
//    init(interactiveBaseProperties: T) {
//        self.interactiveBaseProperties = interactiveBaseProperties
//    }
//}
final class FooterComponentViewModel: ObservableObject {
    @Published var interactiveProperties: InteractiveField

    init(interactiveProperties: InteractiveField) {
        self.interactiveProperties = interactiveProperties
    }
}
