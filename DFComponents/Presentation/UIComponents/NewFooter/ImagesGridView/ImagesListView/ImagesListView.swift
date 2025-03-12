//
//  ImagesListView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ImageListView: View {
    @Binding var attachments: [AttachmentModel]
    @State private var isSelecting = false
    @State private var selectedImages: Set<UUID> = []
    @State private var selectedImage: AttachmentModel?  // Track selected image for detail view
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        let imageAttachments = attachments.filter { $0.isImage }

        NavigationView {
            VStack {
                // Header
                HStack {
                    if isSelecting {
                        Button("Cancel") {
                            isSelecting = false
                            selectedImages.removeAll()
                        }
                        .foregroundColor(.blue)
                    } else {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }

                    Spacer()

                    VStack {
                        Text("Images")
                            .font(.headline)
                        Text("\(imageAttachments.count) Photos")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    if isSelecting {
                        Button(selectedImages.count == imageAttachments.count ? "Deselect All" : "Select All") {
                            if selectedImages.count == imageAttachments.count {
                                selectedImages.removeAll()
                            } else {
                                selectedImages = Set(imageAttachments.map { $0.id })
                            }
                        }
                        .foregroundColor(.blue)
                    } else {
                        Button("Select") {
                            isSelecting = true
                        }
                        .foregroundColor(.blue)
                    }
                }
                .padding()

                // Image Grid/List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(imageAttachments) { attachment in
                            if let image = attachment.image {
                                ZStack(alignment: .topLeading) {
                                    if isSelecting {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedImages.contains(attachment.id) ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                            .onTapGesture {
                                                toggleSelection(for: attachment.id)
                                            }

                                        Image(systemName: selectedImages.contains(attachment.id) ? "checkmark.circle.fill" : "circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(selectedImages.contains(attachment.id) ? .blue : .gray)
                                            .background(Color.white.clipShape(Circle()))
                                            .padding(10)
                                    } else {
                                        // **Navigate to ImageDetailView when tapped**
                                        Button(action: {
                                            selectedImage = attachment
                                        }) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // **Bottom Bar with Edit & Delete Buttons**
                if isSelecting && !selectedImages.isEmpty {
                    VStack(spacing: 0) {
                        Divider()  // Adds a separator line above the bar

                        HStack {
                            Button(action: {}) {
                                Image(.edit)
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                            }
                            .frame(width: 50, height: 50)

                            Spacer()

                            Text("\(selectedImages.count) Photo\(selectedImages.count > 1 ? "s" : "") Selected")
                                .font(.system(size: 16, weight: .bold))

                            Spacer()

                            Button(action: deleteSelectedImages) {
                                Image(.delete)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red) 
                            }
                            .frame(width: 50, height: 50)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 60)
                        .background(Color(UIColor.systemGray6))
                    }
                }
            }
            .navigationBarHidden(true)  // Ensures navigation bar is hidden
            .toolbar(.hidden, for: .navigationBar)  // iOS 15+ explicit hiding
            .background(
                NavigationLink(
                    destination: selectedImage.map { ImageDetailView(attachments: $attachments, image: $0) },
                    isActive: Binding(
                        get: { selectedImage != nil },
                        set: { if !$0 { selectedImage = nil } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())  // Ensures proper rendering on iPads
        .navigationBarHidden(true)  // Double-check hiding
    }

    private func toggleSelection(for id: UUID) {
        if selectedImages.contains(id) {
            selectedImages.remove(id)
        } else {
            selectedImages.insert(id)
        }
    }

    private func deleteSelectedImages() {
        attachments.removeAll { selectedImages.contains($0.id) }

        if attachments.filter({ $0.isImage }).isEmpty {
            presentationMode.wrappedValue.dismiss() // Dismiss view if no images left
        }

        selectedImages.removeAll()
        isSelecting = false
    }
}
