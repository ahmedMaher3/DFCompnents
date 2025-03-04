//
//  FormBuilderRepo.swift
//  DFComponents
//
//  Created by ahmed maher on 23/02/2025.
//

import Foundation

protocol FormBuildRepository {
    func fetchForm() async throws -> Schema
}

enum FormRepositoryError: Error {
    case fileNotFound
}

final class LocalFormRepository: FormBuildRepository {
    func fetchForm() async throws -> Schema {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let path = Bundle.main.path(forResource: "checkSurvey", ofType: "json") else {
                    continuation.resume(throwing: FormRepositoryError.fileNotFound)
                    return
                }
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    let schema = apiResponse.data.schema
                   // let formEntity = FormEntity(apiResponse.data.schema)
                    continuation.resume(returning: schema)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
