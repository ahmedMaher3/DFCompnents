//
//  PageFooterView.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

import SwiftUI

struct PageFooterView: View {

    @Binding var currentPage: Int
    let totalPages: Int
    let pageProperties: PageProperties
    
    var body: some View {
        HStack {
            
            if pageProperties.backVisibility ?? true {
                if currentPage != 0 {
                    Button(action: {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(pageProperties.back ?? "")
                        }
                        .foregroundColor(currentPage > 0 ? .blue : .gray)
                    }
                }
            }

            Spacer()

            if currentPage < totalPages - 1 {
                Button(action: {
                    if currentPage < totalPages - 1 {
                        currentPage += 1
                    }
                }) {
                    HStack {
                        Text(pageProperties.next ?? "")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(currentPage < totalPages - 1 ? .blue : .gray)
                }
            }
        }
        .padding()
        .frame(height: 55)
        .background(Color(.systemGray6))

    }

    
}
