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
    private func footerStack(interactiveControl: InteractiveField, characterCountText: String?, tooltip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sublabel = interactiveControl.sublabel {
                HStack(alignment: .center, spacing: 8) {
                    Text(sublabel)
                    Spacer()
                    HStack(alignment: .center,spacing: 4) {
                        if !(tooltip.isEmpty ?? false ) {
                            ToolTipFooterView(tooltip: tooltip ?? "")
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
            if interactiveControl.addNote || interactiveControl.addAttachment {
                HStack {
                    renderNoteButton()
                    renderAttachmentButton()
                }
                renderSavedNote()
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
                    updateAnswer()
                }
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
            .id(UUID()) // Ensures sheet gets recreated properly
            .presentationDetents([.large])
            .presentationCornerRadius(20)
        }
    }
    
    /// **Render Footer Based on Field Type**
    @ViewBuilder
    private func renderFooter(fieldEntity: FieldEntity) -> some View {
        switch fieldEntity {
        case .page, .section, .radio, .textBox:
            EmptyView() // Ensure a valid View is returned

        case .number((_, let numberViewModel)):
            let interactiveProperties = numberViewModel.numberFieldModel.base
            let characterCountText = numberViewModel.characterCountText
            let tooltip: String = {
                guard let fieldValidation = numberViewModel.numberFieldModel.fieldWarning?.fieldValidation else { return "" }
                var messages: [String] = []
                if let minDigits = numberViewModel.numberFieldModel.minimumDigits {
                    if let minMessage = getErrorMessage(for: fieldValidation, validationKey: .minimumDigits, value: minDigits), !minMessage.isEmpty {
                        messages.append(minMessage)
                    }
                }
                if let maxDigits = numberViewModel.numberFieldModel.maximumDigits {
                    if let maxMessage = getErrorMessage(for: fieldValidation, validationKey: .maximumDigits, value: maxDigits), !maxMessage.isEmpty {
                        messages.append(maxMessage)
                    }
                }
                return messages.joined(separator: "\n")
            }()
            footerStack(
                interactiveControl: interactiveProperties,
                characterCountText: characterCountText,
                tooltip: tooltip
            )
        }
    }


    @ViewBuilder
    private func renderNoteButton() -> some View {
        Button(action: { showNotePopup.toggle() }) {
            Image(.addNote)
                .foregroundColor(.blue)
                .font(.title2)
        }
    }

    @ViewBuilder
    private func renderAttachmentButton() -> some View {
        AttachmentButton(showImagePicker: $showImagePicker, showFilePicker: $showFilePicker, selectedPhotos: $selectedPhotos)
    }

    @ViewBuilder
    private func renderSavedNote() -> some View {
        if let note = savedNote, !(note.isEmpty ) {
            VStack(alignment: .leading) {
                let noteText = note.count >= 80 ? note.prefix(80) + "..." : note
                Text(isExpanded ? note : noteText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .lineLimit(isExpanded ? nil : 2)
                
                if note.count > 80 {
                    Button(action: { isExpanded.toggle() }) {
                        Text(isExpanded ? "Less" : "More")
                            .foregroundColor(.blue)
                            .font(.caption)
                            .bold()
                    }
                    .padding(.top, 4)
                }
            }
        }
    }
    func getErrorMessage(for validationEntity: FieldValidationEntity, validationKey: ValidationKey, value: Any? = nil) -> String? {
        switch validationKey {
        case .required:
            return validationEntity.required
        case .maxAttachment:
            return validationEntity.maxAttachment

        // Input Validations
        case .minimumCharacterLength:
            return validationEntity.input.minimumCharacterLength.replaceValidationWith(value)
        case .maximumCharacterLength:
            return validationEntity.input.maximumCharacterLength.replaceValidationWith(value)
        case .minimumWordLength:
            return validationEntity.input.minimumWordLength.replaceValidationWith(value)
        case .maximumWordLength:
            return validationEntity.input.maximumWordLength.replaceValidationWith(value)
        case .email:
            return validationEntity.input.email
        case .url:
            return validationEntity.input.url
        case .numeric:
            return validationEntity.input.numeric
        case .alphabetic:
            return validationEntity.input.alphabetic
        case .alphanumeric:
            return validationEntity.input.alphanumeric
        case .custom:
            return validationEntity.input.custom

        // Number Validations
        case .minimumValue:
            return validationEntity.number.minimumValue?.replaceValidationWith(value)
        case .maximumValue:
            return validationEntity.number.maximumValue?.replaceValidationWith(value)
        case .minimumDigits:
            return validationEntity.number.minimumDigits?.replaceValidationWith(value)
        case .maximumDigits:
            return validationEntity.number.maximumDigits?.replaceValidationWith(value)

        // DateTime Validations
        case .dateTime:
            return validationEntity.dateTime.dateTime
        case .dateRange:
            return validationEntity.dateTime.dateRange

        // MCQ Validations
        case .minimumNumberOfSelectedOptions:
            return validationEntity.mcq.minimumNumberOfSelectedOptions
        case .maximumNumberOfSelectedOptions:
            return validationEntity.mcq.maximumNumberOfSelectedOptions

        // File Upload Validations
        case .maxFilesSize:
            return validationEntity.fileUpload.maxFilesSize
        case .maxSizePerFile:
            return validationEntity.fileUpload.maxSizePerFile
        case .minNumberOfFiles:
            return validationEntity.fileUpload.minNumberOfFiles
        case .maxNumberOfFiles:
            return validationEntity.fileUpload.maxNumberOfFiles
        case .allowedExtensions:
            return validationEntity.fileUpload.allowedExtensions
        case .invalidLink:
            return validationEntity.fileUpload.invalidLink

        // Location Validations
        case .maximumLocations:
            return validationEntity.location.maximumLocations
        case .minimumLocations:
            return validationEntity.location.minimumLocations
        case .notInRange:
            return validationEntity.location.notInRange
        }
    }

    
    /// **Update Answer in ViewModel**
    private func updateAnswer() {
        if case .number((_, let numberViewModel)) = viewModel.field {
            numberViewModel.numberFieldModel.answer = BaseAnswerNumber(value:numberViewModel.baseAnswer?.value ?? "" ,note: savedNote ?? "", attachments: attachments)
            
        }
    }
}
