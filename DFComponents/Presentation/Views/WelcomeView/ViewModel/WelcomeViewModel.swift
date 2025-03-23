//
//  WelcomeViewModel.swift
//  DFComponents
//
//  Created by mac on 3/6/25.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    let id = UUID() // Ensure each instance is uniquely identifiable
    @Published var welcomeData: WelcomeEntity
    
    init(welcomeData: WelcomeEntity) {
        self.welcomeData = welcomeData
    }

}
