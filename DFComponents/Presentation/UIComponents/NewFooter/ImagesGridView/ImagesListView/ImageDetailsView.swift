//
//  ImageDetailsView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers


struct ImageDetailView: View {
    @Binding var attachments: [AttachmentModel]
    let image: AttachmentModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding()
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
                    // Handle edit action
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .padding()
                }

                Spacer()

                Button(action: deleteImage) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
        .navigationBarHidden(true)
    }

    private func deleteImage() {
        attachments.removeAll { $0.id == image.id }
        presentationMode.wrappedValue.dismiss() // Pop view after deletion
    }
}
