//
//  FormViewModel.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import Foundation

class FormViewModel: ObservableObject {
    @Published var forms: [FormDTO] = []
    @Published var isLoading: Bool = true
    
    init() {
        Task {
            await fetchForms()
        }
    }
    
    func fetchForms() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let sampleForms: [FormDTO] = [
            FormDTO(name: "Contact Form", fields: ["Name", "Email", "Message"]),
            FormDTO(name: "Survey Form", fields: ["Rating", "Comments"]),
            FormDTO(name: "Application Form", fields: ["Name", "Address", "Experience"])
        ]
        
        await MainActor.run {
            self.forms = sampleForms
            self.isLoading = false
        }
    }
}
