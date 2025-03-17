//
//  FooterView.swift
//  DFComponents
//
//  Created by Eslam on 16/03/2025.
//
import SwiftUI

struct FooterView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack {
            Button(action: {
                if currentPage > 0 {
                    currentPage -= 1
                }
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(currentPage > 0 ? .blue : .gray)
            }
            .disabled(currentPage == 0)
            
            Spacer()
            
            Button(action: {
                if currentPage < totalPages - 1 {
                    currentPage += 1
                }
            }) {
                HStack {
                    Text("Next")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(currentPage < totalPages - 1 ? .blue : .gray)
            }
            .disabled(currentPage >= totalPages - 1)
        }
        .padding()
        .frame(height: 55)
        .background(Color(.systemGray6))
        
    }
}
