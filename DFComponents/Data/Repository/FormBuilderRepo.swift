//
//  FormBuilderRepo.swift
//  DFComponents
//
//  Created by ahmed maher on 23/02/2025.
//

import Foundation

enum FormRepositoryError: Error {
    case fileNotFound
    case decodingFailed(Error)
    case unknown(Error)
}

protocol FormBuildRepositoryProtocol {
    func fetchForm() async throws -> Schema
}


final class FormBuilderRepository: FormBuildRepositoryProtocol {

    func fetchForm() async throws -> Schema {
            do {
                guard let fileURL = Bundle.main.url(forResource: "checkSurvey", withExtension: "json") else {
                    throw FormRepositoryError.fileNotFound
                }

                let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                return apiResponse.data.schema

            } catch let decodingError as DecodingError {
                print("Decoding failed: \(decodingError)")
                throw FormRepositoryError.decodingFailed(decodingError)

            } catch {
                print("Unexpected error: \(error.localizedDescription)")
                throw FormRepositoryError.unknown(error)
            }
        }

}
