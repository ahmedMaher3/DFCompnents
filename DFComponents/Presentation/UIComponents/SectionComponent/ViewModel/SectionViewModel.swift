//
//  SectionViewModel.swift
//  DFComponents
//
//  Created by ahmed maher on 05/02/2025.
//

import Foundation

class SectionViewModel: ObservableObject {
    @Published var sections: [SectionModel] = [
        SectionModel(title: "Fruits", isExpanded: false, items: ["Apple", "Banana", "Orange"]),
        SectionModel(title: "Vegetables", isExpanded: false, items: ["Carrot", "Broccoli", "Lettuce"]),
        SectionModel(title: "Dairy", isExpanded: false, items: ["Milk", "Cheese", "Yogurt"])
    ]

    // Function to toggle the expansion state of a section
    func toggleSection(_ section: SectionModel) {
        if let index = sections.firstIndex(where: { $0.id == section.id }) {
            sections[index].isExpanded.toggle()
        }
    }
}
