//
//  WelcomeViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    let id = UUID() // Ensure each instance is uniquely identifiable
    @Published var welcomeEntity: WelcomeEntity
    
    init(welcomeEntity: WelcomeEntity) {
        self.welcomeEntity = welcomeEntity
    }

}
