//
//  CheckBoxView.swift
//  DFComponents
//
//  Created by Eslam on 29/01/2025.
//

import SwiftUI

struct CheckBoxView: View {
//    @State private var isChecked: Bool = false
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            // 3. Create the Toggle view
//            Toggle(isOn: $isChecked) {
//                // 4. Add a label for the Toggle
//                Text("UnChecked")
//            }
//            .toggleStyle(CheckBoxStyle())
//            .padding()
//        }
//    }
    @State private var selectedItems: Set<String> = []

    let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                Toggle(option, isOn: .constant(selectedItems.contains(option)))
                    .toggleStyle(CheckBoxStyle(selectedItems: $selectedItems, itemID: option))
            }
        }
        .padding()
    }

}

#Preview(traits: .sizeThatFitsLayout) {
    CheckBoxView()
}
