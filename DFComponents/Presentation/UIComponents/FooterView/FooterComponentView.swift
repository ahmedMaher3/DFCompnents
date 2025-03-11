//
//  FooterComponentView.swift
//  DFComponents
//
//  Created by Eslam on 04/03/2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct FooterComponentView: View {
    @StateObject var viewModel: FooterComponentViewModel
    @State private var showNotePopup = false
    @State private var noteText: String = ""
    @State private var savedNote: String?
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedFiles: [URL] = []
    @State private var attachments: [AttachmentModel] = []
    @State private var showFilePicker = false
    @State private var showImagePicker = false

    init(viewModel: FooterComponentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        renderFooter(fieldEntity: viewModel.field)
    }

    /// **Reusable Footer Stack**
    @ViewBuilder
    private func footerStack(sublabel: String?, characterCountText: String?, addNote: Bool, addAttachment: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sublabel = sublabel {
                Text(sublabel)
            }

            if let characterCountText = characterCountText {
                Text(characterCountText)
                    .foregroundStyle(.gray)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding([.top, .trailing], 4)
            }

            if addNote || addAttachment {
                HStack {
                    if addNote {
                        Button(action: { showNotePopup.toggle() }) {
                            Image(systemName: "bubble.left.and.text.bubble.right.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }

                    if addAttachment {
                        // Attachment Button
                        AttachmentButton(showImagePicker: $showImagePicker, showFilePicker: $showFilePicker, selectedPhotos: $selectedPhotos)

                    }
                }

                if let note = savedNote {
                    Text(note)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
     

                // File List
                FileListView(attachments: $attachments)

                // Image Grid
                ImageGridView(attachments: $attachments)
            }
        }
        // Image Picker
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhotos, matching: .images)
        .onChange(of: selectedPhotos) { newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let attachment = AttachmentModel(fileName: "Image.jpg", fileSize: data.count, fileType: "jpg", image: uiImage)
                        attachments.append(attachment)
                    }
                }
            }
        }
        
        // File Picker
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.pdf, .jpeg, .png, .plainText, .spreadsheet, .presentation],
            allowsMultipleSelection: true
        ) { result in
            do {
                let urls = try result.get()
                for url in urls {
                    let fileSize = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int ?? 0
                    let attachment = AttachmentModel(fileName: url.lastPathComponent, fileSize: fileSize, fileType: url.pathExtension)
                    attachments.append(attachment)
                }
            } catch {
                print("Failed to pick file: \(error)")
            }
        }
        .sheet(isPresented: $showNotePopup) {
            NotePopupView(noteText: $noteText, onSave: {
                savedNote = noteText
                showNotePopup = false
            })
            .presentationDetents([.large])
            .presentationCornerRadius(20)
        }
    }

    /// **Render Footer Based on Field Type**
    @ViewBuilder
    private func renderFooter(fieldEntity: FieldEntity) -> some View {
        switch fieldEntity {
        case .page, .section, .radio, .textBox:
            EmptyView()

        case .number((_, let numberViewModel)):
            let interactiveProperties = numberViewModel.numberFieldModel.base
            footerStack(
                sublabel: interactiveProperties.sublabel,
                characterCountText: "\(numberViewModel.characterCount)/\(numberViewModel.numberFieldModel.maximumDigits ?? 0)",
                addNote: interactiveProperties.addNote,
                addAttachment: interactiveProperties.addAttachment
            )
        }
    }
}
