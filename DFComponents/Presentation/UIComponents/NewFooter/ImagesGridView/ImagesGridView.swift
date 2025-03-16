//
//  ImagesGridView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//
import SwiftUI

struct ImageGridView: View {
    @Binding var attachments: [AttachmentModel]
    @State private var showImageList = false
    let maxVisibleImages = 3

    var body: some View {
        NavigationStack {
            VStack {
                if !attachments.filter { $0.isImage }.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            let imageAttachments = attachments.filter { $0.isImage }
                            let visibleImages = Array(imageAttachments.prefix(maxVisibleImages))

                            // Display first maxVisibleImages images normally
                            ForEach(visibleImages) { attachment in
                                if let image = attachment.image {
                                    NavigationLink(destination: ImageDetailView(attachments: $attachments, image: attachment)) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }

                            // If more images exist, show a "+ count" overlay on the last one
                            if imageAttachments.count > maxVisibleImages {
                                let remainingCount = imageAttachments.count - maxVisibleImages

                                NavigationLink(destination: ImageListView(attachments: $attachments)) {
                                    ZStack {
                                        if let lastImage = imageAttachments[maxVisibleImages].image {
                                            Image(uiImage: lastImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .overlay(Color.black.opacity(0.5)) // Dark overlay for contrast
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }

                                        Text("+\(remainingCount)")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .frame(height: 100)
                }
            }
        }
    }
}
