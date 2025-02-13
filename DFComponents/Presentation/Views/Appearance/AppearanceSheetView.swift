//
//  AppearanceSheetView.swift
//  DFComponents
//
//  Created by mac on 2/13/25.
//

import SwiftUI

struct AppearanceSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationStack {
            AppearanceSelectionPicker()
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
               dismiss()
            }) {
               Text("Done").bold()
            })
        }.interactiveDismissDisabled()
    }
}

#Preview {
    AppearanceSheetView()
}
