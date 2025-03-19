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
        renderFooter(field: viewModel.field)
    }

    /// **Reusable Footer Stack**
    @ViewBuilder
    func footerStack(fieldProperties: InteractiveField, charactersCount: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sublabel = fieldProperties.sublabel {
                HStack(alignment: .center, spacing: 8) {
                    Text(sublabel)

                    Spacer()

                    HStack(alignment: .center,spacing: 4) {
                        if !(fieldProperties.tooltip?.isEmpty ?? true ) {
                            ToolTipFooterView(tooltip: fieldProperties.tooltip ?? "")
                        }
                        if !charactersCount.isEmpty {
                            Text(charactersCount)
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
            if fieldProperties.addNote || fieldProperties.addAttachment {
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
    private func renderFooter(field: (any FieldRenderable)?) -> some View {
        switch field?.field.type {
        case .page, .section, .radio, .textBox:
            EmptyView()
        case .number:
            if let numberField = field?.field as? NumberField {
                footerStack(fieldProperties: numberField.base, charactersCount: "")
            }
        default :
            EmptyView()
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
    /// **Update Answer in ViewModel**
    private func updateAnswer() {
        
//        if viewModel.field.field.type == .number  {
//            if var numberField = viewModel.field.field as? NumberField {
//            let answerValue = (numberField.base.answer as? BaseAnswerNumber)?.value
//                numberField.answer = BaseAnswerNumber(value: answerValue ?? "" ,note: savedNote ?? "", attachments: attachments)
//            }
//        }
    }
}
