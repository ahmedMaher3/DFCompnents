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
                    continuation.resume(returning: schema)
                } catch let decodingError as DecodingError {
                    print("Decoding failed: \(decodingError)")
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type): \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type \(type): \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    @unknown default:
                        print("Unknown decoding error")
                    }

                    continuation.resume(throwing: decodingError)
                } catch {
                    print("Unexpected error: \(error.localizedDescription)")
                    print("bi7asl ah hana:\(error)")
                    continuation.resume(throwing: error)
                }

            }
        }
    }
}
