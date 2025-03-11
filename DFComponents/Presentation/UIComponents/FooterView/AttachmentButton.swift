//
//  AttachmentButton.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import Foundation
import SwiftUI

// MARK: - Attachment Button
struct AttachmentButton: View {
    @Binding var showImagePicker: Bool
    @Binding var showFilePicker: Bool
    
    var body: some View {
        Menu {
            Button("Upload Image", action: { showImagePicker.toggle() })
            Button("Upload File", action: { showFilePicker.toggle() })
        } label: {
            Image(systemName: "paperclip")
                .foregroundColor(.blue)
                .font(.title2)
        }
    }
}

