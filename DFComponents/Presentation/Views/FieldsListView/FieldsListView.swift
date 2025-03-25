//
//  FieldsListView.swift
//  DFComponents
//
//  Created by Yasser Osama on 3/25/25.
//

import SwiftUI

struct FieldsListView: View {
    @Environment(\.dismiss) var dismiss
    var fields: [BaseFieldProtocol]
    var formType: FormType = .classic
    var onTap: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 20) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    Text(formType == .classic ? "Pages" : "Questions")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                .padding()
                Divider()
                List(fields.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        let questionNumber = formType == .card ? "\(index + 1). " : ""
                        Text(questionNumber + "" + fields[index].label)
                            .font(.body)
                            .foregroundColor(.black)
                        if formType == .classic {
                            HStack {
                                Text("completed/total questions")
                                    .font(.subheadline)
                                    .bold()
                                    .opacity(formType == .classic ? 1 : 0)
                                
                                // check if errors and display them
    //                            if page.errors > 0 {
    //                                Text(", \(page.errors) Errors")
    //                                    .foregroundColor(.red)
    //                                    .bold()
    //                            }
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        } else {
                            
                        }
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        onTap(fields[index].fieldId)
                        dismiss()
                    }
                }
                .listStyle(.plain)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    FieldsListView(fields: []) { _ in
    }
}
