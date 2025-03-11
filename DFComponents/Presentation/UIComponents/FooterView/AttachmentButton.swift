//
//  AttachmentButton.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Attachment Button
struct AttachmentButton: View {
    @Binding var showImagePicker: Bool
    @Binding var showFilePicker: Bool
    @Binding var selectedPhotos: [PhotosPickerItem] // Pass binding to clear it
    @State private var showCamera = false
    @State private var capturedImage: UIImage?

    var body: some View {
        Menu {
            Button("Take Photo", action: { showCamera.toggle() })
            Button("Upload Image", action: {
                selectedPhotos.removeAll() // Reset selection before opening picker
                showImagePicker.toggle()
            })
            Button("Upload File", action: { showFilePicker.toggle() })
        } label: {
            Image(systemName: "paperclip")
                .foregroundColor(.blue)
                .font(.title2)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $capturedImage)
        }
    }
}
