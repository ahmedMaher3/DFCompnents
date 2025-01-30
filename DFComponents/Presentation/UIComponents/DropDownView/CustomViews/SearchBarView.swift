//
//  SearchBarView.swift
//  iOS Chanllenge
//
//  Created by ahmed maher .
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String

    var body: some View {
        TextField("Search countries", text: $text)
            .padding(12)
            .padding(.horizontal, 25)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                    }
                }
            )
            .padding(.horizontal)
    }
}
