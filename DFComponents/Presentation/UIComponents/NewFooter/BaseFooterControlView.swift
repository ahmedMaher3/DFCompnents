//
//  BaseFooterControlView.swift
//  DFComponents
//
//  Created by hassan elshaer on 11/03/2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct BaseFooterControlView: View {
    @StateObject var viewModel: BaseFooterViewModel
    @State private var showNotePopup = false
    @State private var noteText: String = ""
    @State private var savedNote: String?
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedFiles: [URL] = []
    @State private var attachments: [AttachmentModel] = []
    @State private var showFilePicker = false
    @State private var showImagePicker = false
    @State private var isExpanded: Bool = false
    @State private var showPopover = false
    
    init(viewModel: BaseFooterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        renderFooter(fieldEntity: viewModel.field)
    }
    
    /// **Reusable Footer Stack**
    @ViewBuilder
    private func footerStack(sublabel: String?, characterCountText: String?, addNote: Bool, addAttachment: Bool, tooltip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sublabel = sublabel {
                HStack(alignment: .center, spacing: 8) {
                    Text(sublabel)
                    
                    Spacer()
                    
                    HStack(alignment: .center,spacing: 4) {
                        if !(tooltip.isEmpty ) {
                            ZStack {
                                Image(.pinToolTip)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        showPopover.toggle()
                                    }
                                    .popover(isPresented: $showPopover, attachmentAnchor: .point(.center), arrowEdge: .top) {
                                        ZStack {
                                            Color.primaryBlue
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(tooltip)
                                            }
                                            .font(.system(size: 12))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding()
                                        }
                                        .background(.primaryBlue)
                                        .presentationCompactAdaptation(.popover)
                                    }
                            }
                        }
                        if let characterCountText = characterCountText {
                            Text(characterCountText)
                                .foregroundStyle(.gray)
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 0)
                    .padding(.trailing, 2)
                }
            }
            
            if addNote || addAttachment {
                HStack {
                    if addNote {
                        Button(action: { showNotePopup.toggle() }) {
                            Image(.addNote)
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    
                    if addAttachment {
                        AttachmentButton(showImagePicker: $showImagePicker, showFilePicker: $showFilePicker, selectedPhotos: $selectedPhotos)
                    }
                }
                
                if let note = savedNote, !(note.isEmpty ?? true) {
                    VStack(alignment: .leading) {
                        let noteText = note.count >= 80 ? note.prefix(80) + "..." : note
                        Text(isExpanded ? note : noteText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .lineLimit(isExpanded ? nil : 2)
                        Button(action: { isExpanded.toggle() }) {
                            if note.count > 80 {
                                Text(isExpanded ? "Less" : "More")
                                    .foregroundColor(.blue)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        .padding(.top, 4)
                    }
                }
                
                FileListView(attachments: $attachments)
                ImageGridView(attachments: $attachments)
            }
        }
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhotos, matching: .images)
        .onChange(of: selectedPhotos) { newItems in
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let attachment = AttachmentModel(fileName: "Image.jpg", fileSize: data.count, fileType: "jpg", image: uiImage)
                        attachments.append(attachment)
                        updateAnswer()
                    }
                }
            }
        }
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
                updateAnswer()
            } catch {
                print("Failed to pick file: \(error)")
            }
        }
        .sheet(isPresented: $showNotePopup) {
            NotePopupView(noteText: $noteText, onSave: {
                savedNote = noteText
                showNotePopup = false
                updateAnswer()
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
                addAttachment: interactiveProperties.addAttachment,
                tooltip: interactiveProperties.tooltip ?? "test test test"
            )
        }
    }
    
    /// **Update Answer in ViewModel**
    private func updateAnswer() {
        if case .number((_, let numberViewModel)) = viewModel.field {
            numberViewModel.numberFieldModel.answer = BaseAnswer(note: savedNote ?? "", attachments: attachments)
        }
    }
}
