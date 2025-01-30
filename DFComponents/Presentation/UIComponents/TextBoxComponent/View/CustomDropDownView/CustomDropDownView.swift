//
//  CustomDropDownView.swift
//  DFComponents
//
//  Created by hassan elshaer on 30/01/2025.
//

import SwiftUI

// MARK: - DropdownView
struct CustomDropdownView: View {
    @Binding var selectedOption: String?
    let options: [String]
    let label: String
    let borderColor: Color  // Pass border color from parent view model
    
    private var textColor: Color {
        (selectedOption == nil || selectedOption?.isEmpty == true) ? Color(hex: "9EB3C2") : Color.black
    }
    
    var body: some View {
        if options.count == 1, let option = selectedOption {
            Text(option)
                .frame(height: 48)
                .padding(.horizontal)
                .foregroundColor(textColor)
                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 2))
        } else {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption ?? label)
                        .foregroundColor(textColor)
                    if options.count > 1 {
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(hex: "#173E67"))
                    }
                }
                .frame(height: 48)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 2)) //
            }
        }
    }
}

#Preview {
    struct DropdownPreview: View {
        @State private var selectedOption: String? = nil
        private let options = ["Option 1", "Option 2", "Option 3"]
        
        var body: some View {
            VStack {
                CustomDropdownView(
                    selectedOption: $selectedOption,
                    options: options,
                    label: "Select an option",
                    borderColor: .gray
                )
                .padding()
            }
        }
    }
    
    return DropdownPreview()
}

