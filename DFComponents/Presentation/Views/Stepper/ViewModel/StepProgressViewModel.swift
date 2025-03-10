//
//  StepProgressViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 09/03/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

class StepProgressViewModel: ObservableObject {
    @Published var totalPages: [String] = []
    @Published var currentPage: Int = 0
    @Published var enablePageValidation:  Bool = true
    @Published private(set) var progress: Double = 0.0
    @Published private(set) var completionPercentage: Int = 0




    init(pages: [String] = ["1", "2", "3"], currentPage: Int = 0,enablePageValidation: Bool = false) {

        self.totalPages = pages
        self.currentPage = currentPage
        self.enablePageValidation = enablePageValidation

    }

    func updateCurrentPage(_ index: Int) {
        guard index >= 0, index < totalPages.count else { return }
        currentPage = index
    }

     func updateProgress(){
        self.progress = Double(currentPage + 1) / Double(totalPages.count)
         self.completionPercentage = Int((Double(currentPage + 1) / Double(totalPages.count)) * 100)
    }




}
