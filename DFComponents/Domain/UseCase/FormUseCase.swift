//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormBuildUseCaseProtocol {
    func excute() async throws -> FormEntity
    func map(dto: Schema) -> [FieldEntity]
}


class FormBuildUseCase: FormBuildUseCaseProtocol {


    private let repository: FormBuildRepository
    private let mapper: any EntityMapper


    init(repository: FormBuildRepository = LocalFormRepository(), mapper: any EntityMapper = FormMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    func excute() async throws -> FormEntity {
        do {
            let response = try await repository.fetchForm()
            let controls = map(dto: response)
            return FormEntity(fields: controls, rules: response.rules, mode: response.settings.format)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return FormEntity(fields: [], rules: [], mode: nil)
        }
    }

    func map(dto: Schema) -> [FieldEntity] {
         let entityMapper = mapper as! FormMapper
        return entityMapper.map(from: dto)
    }
}
