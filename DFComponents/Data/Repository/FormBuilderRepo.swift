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

struct CountryEndPoint: Endpoint {

    var path: String = "all"
    var method: HTTPMethod = .GET
    var headers: [String: String]  = [:]
    var body: Data?  = nil

}


struct Country : Codable, Identifiable,Hashable{

    var id: String { alpha3Code }
    let name: String
    let alpha2Code, alpha3Code: String
    let capital: String?
    let flag: Int?

    init(name: String) {
        self.name = ""
        self.alpha2Code = ""
        self.alpha3Code = ""
        self.capital = ""
        self.flag = 0
    }

}

protocol CountryRepositoryProtocol {
    func fetchCountries() async throws -> [Country]
}

class CountryRepository: CountryRepositoryProtocol {

    private let network: NetworkProtocol

    init(network: NetworkProtocol = NetworkClient()) {
        self.network = network
    }

    func fetchCountries() async throws -> [Country] {
        let countries: [Country] =  try await network.request(CountryEndPoint())
        return countries
    }
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
