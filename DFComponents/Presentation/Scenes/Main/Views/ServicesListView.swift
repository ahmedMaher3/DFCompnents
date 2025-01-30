//
//  FormListView.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import SwiftUI

struct ServicesListView: View {
    @StateObject var viewModel = ServicesListViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
//                    ProgressView()
                } else {
                    List {
                        ForEach(filteredForms) { form in
                            NavigationLink(destination: FormView(title: form.name)) {
                                FormRow(form: form)
                            }
                  
                        }
                    }
                    .searchable(text: $searchText, prompt: "Forms Search")
                }
            }
            .navigationTitle("Services")
        }
    }
    
    var filteredForms: [FormDTO] {
        guard !searchText.isEmpty else {
            return viewModel.forms
        }
        
        return viewModel.forms.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }
}

struct FormRow: View {
    let form: FormDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Add spacing within the row
            Text(form.name)
                .font(.title2)
                .foregroundColor(.primaryBlue)
            
            Text(form.fields.joined(separator: ", "))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
    }
}


#Preview {
    ServicesListView()
}
