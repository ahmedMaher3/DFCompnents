//
//  FormListView.swift
//  DFComponents
//
//  Created by Yasser Osama on 1/30/25.
//

import SwiftUI

struct FormListView: View {
    @StateObject var viewModel = FormListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.forms) { form in
                            NavigationLink(destination: FormView()) {
                                Text(form.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Forms")
        }
    }
}

#Preview {
    FormListView()
}
