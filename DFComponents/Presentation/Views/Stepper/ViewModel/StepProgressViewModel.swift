//
//  StepProgressViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 09/03/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

struct PageProgressView {
    var totalPages: Int
    var currentPage: Int
}

class StepProgressViewModel: ObservableObject {
    @Published var totalPages: Int = 0
    @Published var currentPage: Int = 0
    @Published private(set) var progress: Double = 0.0
    @Published private(set) var completionPercentage: Int = 0


    func updateCurrentPage(_ index: Int) {
        guard index >= 0, index < totalPages else { return }
        currentPage = index
    }

     func updateProgress(){
         self.progress = Double(currentPage + 1) / Double(totalPages)
        // self.completionPercentage = Int((Double(currentPage + 1) / Double(totalPages)) * 100)
    }

}
