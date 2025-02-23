//
//  FormBuilderRepo.swift
//  DFComponents
//
//  Created by ahmed maher on 23/02/2025.
//

import Foundation

protocol FormBuildRepository {
    func fetchForm() async throws -> [FieldDTOEnum]
}

enum FormRepositoryError: Error {
    case fileNotFound
}

final class LocalFormRepository: FormBuildRepository {
    func fetchForm() async throws -> [FieldDTOEnum] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let path = Bundle.main.path(forResource: "checkSurvey", ofType: "json") else {
                    continuation.resume(throwing: FormRepositoryError.fileNotFound)
                    return
                }

                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    let formData = apiResponse.data.schema.fields
                    continuation.resume(returning: formData)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
