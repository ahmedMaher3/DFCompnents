//
//  LoadingView.swift
//  DFComponents
//
//  Created by ahmed maher on 19/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading form data...")
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

#Preview {
    LoadingView()
}
