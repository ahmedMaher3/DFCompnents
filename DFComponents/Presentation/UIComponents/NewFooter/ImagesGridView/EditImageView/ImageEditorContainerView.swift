//
//  Untitled.swift
//  DFComponents
//
//  Created by hassan elshaer on 24/03/2025.
//
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import ZLImageEditor


// MARK: - UIViewControllerRepresentable for ZLImageEditor
struct ImageEditorWrapper: UIViewControllerRepresentable {
    var image: UIImage
    var onEditComplete: (UIImage) -> Void

    func makeUIViewController(context: Context) -> ZLEditImageViewController {
        let config = ZLImageEditorConfiguration.default()
        config.editImageTools([.clip,.textSticker,.draw])
        let editor = ZLEditImageViewController(image: image)
        
        editor.editFinishBlock = { editedImage, _ in
            onEditComplete(editedImage) // Pass back the edited image
        }
        editor.cancelBtn.isHidden = true
        return editor
    }

    func updateUIViewController(_ uiViewController: ZLEditImageViewController, context: Context) {}
}

import SwiftUI

struct ImageEditorContainerView: View {
    @State private var editedImage: UIImage?
    let originalImage: UIImage
    let onClose: (UIImage?) -> Void // Pass edited image on close
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Button(action: {
                    onClose(originalImage)
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) { // Close button with edited image
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("Edit Image")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.left") // Invisible button for layout balance
                    .opacity(0)
            }
            .padding()
            .background(Color.blue.opacity(0.1))

            // Instruction Text
            Text("Use your finger to draw on the image and show us where the problem is")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            // Image Editor
            ZStack {
                if let image = editedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    ImageEditorWrapper(image: originalImage) { newImage in
                        self.editedImage = newImage
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom Buttons
            HStack {
                // Undo Button (Clears edits)
                Button("Undo") {
                    self.editedImage = nil
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

                // Save Button (Saves and Pops Screen)
                Button("Save") {
                    if let image = editedImage {
                        onClose(image) // Pass edited image and dismiss
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss() // ✅ Pop view after saving
                        }
                    } else {
                        print("Error: No edited image available") // Debugging output
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
