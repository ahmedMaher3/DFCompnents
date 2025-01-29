//
//  RadioButtonView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct RadioButtonView: View {
    var body: some View {
        Button {
            //MARK: - Action Button
        } label: {
            HStack {
                Image(systemName: "circle")
                    .customizeImage(width: 24,
                                    height: 24,
                                    type: .primaryGray,
                                    contentMode: .fit,
                                    renderingMode: .original)


                Text("Radio button")
                    .color(.primaryBlue)
            }
        }
        .padding(8)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    RadioButtonView()
}
