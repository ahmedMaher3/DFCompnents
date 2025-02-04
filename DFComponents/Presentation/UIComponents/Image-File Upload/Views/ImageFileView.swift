//
//  ImageFileView.swift
//  DFComponents
//
//  Created by Yasser Osama on 2/3/25.
//

import SwiftUI
import PhotosUI
import WebKit
//import UniformTypeIdentifiers

struct ImagePickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            PhotosPicker("Select Image", selection: $selectedItem, matching: .images)
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImage = UIImage(data: data)
                }
            }
        }
    }
}

struct FilePickerView: View {
    @State private var selectedFileURL: URL?
    @State private var isPickerPresented = false
    @State private var fileData: Data?
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let url = selectedFileURL {
                FileDisplayView(fileURL: url, fileData: fileData, image: selectedImage)
            }

            Button("Pick a File") {
                isPickerPresented = true
            }
            .fileImporter(isPresented: $isPickerPresented, allowedContentTypes: [.item]) { result in
                switch result {
                case .success(let url):
                    selectedFileURL = url
                    loadFileData(from: url)
                case .failure(let error):
                    print("File selection error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadFileData(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            self.fileData = data
            
            // If the file is an image, load it
            if let image = UIImage(data: data) {
                self.selectedImage = image
            } else {
                self.selectedImage = nil
            }
        } catch {
            print("Error reading file data: \(error.localizedDescription)")
        }
    }
}

struct FileDisplayView: View {
    let fileURL: URL
    let fileData: Data?
    let image: UIImage?

    @State private var isSheetPresented = false
    
    var body: some View {
        VStack(spacing: 10) {
            Text("File Name: \(fileURL.lastPathComponent)")
                .bold()

            Text("File Size: \(formattedSize(fileData?.count ?? 0))")
                .foregroundColor(.gray)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            } else {
                Text("File Type: \(fileURL.pathExtension.uppercased())")
                    .padding(8)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        isSheetPresented.toggle()
                    }
                    .sheet(isPresented: $isSheetPresented) {
                        NavigationView {
                            WebView(url: fileURL)
                                .toolbar {
                                    ToolbarItem(placement: .topBarLeading) {
                                        Button("Close") {
                                            isSheetPresented = false
                                        }
                                    }
                                }
                        }
                    }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }

    private func formattedSize(_ bytes: Int) -> String {
        let kb = Double(bytes) / 1024
        return String(format: "%.2f KB", kb)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

#Preview("Image Picker") {
    ImagePickerView()
}

#Preview("File Picker") {
    FilePickerView()
}
