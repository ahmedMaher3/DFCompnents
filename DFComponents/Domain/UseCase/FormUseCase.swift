//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormBuildUseCaseProtocol {
    func excute() async throws -> [Country]
    func map(dto: Schema) -> FormEntity
}

class FormBuildUseCase: FormBuildUseCaseProtocol {

    private let repository: CountryRepositoryProtocol
    private let mapper: any EntityMapper

    //    init(repository: FormBuildRepositoryProtocol = FormBuilderRepository(),
    //         mapper: any EntityMapper = FormMapper()) {
    //        self.repository = repository
    //        self.mapper = mapper
    //    }
    init(repository: CountryRepositoryProtocol = CountryRepository(),
         mapper: any EntityMapper = FormMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    func excute() async throws -> [Country] {
        do {
            let response = try await repository.fetchCountries()
            //   let formEntity: FormEntity = map(dto: response)
            return response
        }
        catch let error as NetworkError {  // Explicitly handling NetworkError
            print("Network Error: \(error.localizedDescription)")
            throw error
        } catch {
            print("Unexpected Error: \(error)")
            throw error

        }

    }


    //    func excute() async throws -> FormEntity {
    //        do {
    //            let response = try await repository.fetchForm()
    //            let formEntity: FormEntity = map(dto: response)
    //            return formEntity
    //        }
    //        catch let error as NSError {
    //            print(error.localizedDescription)
    //            return FormEntity(pages: [], rules: [], warnings: nil)
    //        }
    //    }

    func map(dto: Schema) -> FormEntity {
        let entityMapper = mapper as! FormMapper
        return entityMapper.map(from: dto)
    }


}
