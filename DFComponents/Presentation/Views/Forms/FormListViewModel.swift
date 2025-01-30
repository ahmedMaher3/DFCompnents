//
//  FormListViewModel.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import Foundation

class FormListViewModel: ObservableObject {
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
            FormDTO(name: "Application Form", fields: ["Name", "Address", "Experience"]),
            FormDTO(name: "Feedback Form", fields: ["Feedback"]),
            FormDTO(name: "Inspection Form", fields: ["Inspection Date", "Issues Found"]),
            FormDTO(name: "Checklist Form", fields: ["Checklist Items"]),
        ]
        
        await MainActor.run {
            self.forms = sampleForms
            self.isLoading = false
        }
    }
}
