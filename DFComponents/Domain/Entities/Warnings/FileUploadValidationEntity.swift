//
//  FileUploadValidationEntity.swift
//  DFComponents
//
//  Created by Eslam on 03/03/2025.
//
struct FileUploadValidationEntity {
    let maxFilesSize: String
    let maxSizePerFile: String
    let minNumberOfFiles: String
    let maxNumberOfFiles: String
    let allowedExtensions: String
    let invalidLink: String
}
extension FileUploadValidationEntity {
    init(from dto: FileUploadValidation) {
        self.init(
            maxFilesSize: dto.maxFilesSize,
            maxSizePerFile: dto.maxSizePerFile,
            minNumberOfFiles: dto.minNumberOfFiles,
            maxNumberOfFiles: dto.maxNumberOfFiles,
            allowedExtensions: dto.allowedExtensions,
            invalidLink: dto.invalidLink
        )
    }
}
