//
//  ImageDetailsView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI

struct ImageDetailView: View {
    @Binding var attachments: [AttachmentModel]
    let image: AttachmentModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isEditing = false
    @State private var navigateToEditor = false // ✅ State variable to trigger navigation

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(.arrowLeft)
                        .padding(24)
                }
                
                Spacer()
                
                Text("Image Detail")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            
            if let uiImage = image.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    navigateToEditor = true // ✅ Trigger navigation
                }) {
                    Image(.edit)
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Button(action: deleteImage) {
                    Image(.delete)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            // ✅ NavigationLink should be outside of the Button
            NavigationLink(
                destination: ImageEditorContainerView(
                    originalImage: image.image ?? UIImage(),
                    onClose: { newImage in
                        updateEditedImage(newImage ?? UIImage())
                    }
                ),
                isActive: $navigateToEditor
            ) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func deleteImage() {
        attachments.removeAll { $0.id == image.id }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func updateImage(_ newImage: UIImage) {
        if let index = attachments.firstIndex(where: { $0.id == image.id }) {
            attachments[index].image = newImage
        }
    }
    
    private func updateEditedImage(_ newImage: UIImage) {
        DispatchQueue.main.async {
            if let index = attachments.firstIndex(where: { $0.id == image.id }) {
                var updatedImage = attachments[index]
                updatedImage.image = newImage
                attachments[index] = updatedImage
            }
        }
    }
}
