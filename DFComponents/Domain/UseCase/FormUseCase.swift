//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormBuildUseCaseProtocol{
    func excute() async throws -> [FieldEntity]
    func map(dto: FieldDTOEnum) -> FieldEntity
}


class FormBuildUseCase: FormBuildUseCaseProtocol {


    private let repository: FormBuildRepository
    private let mapper: any EntityMapper


    init(repository: FormBuildRepository = LocalFormRepository(), mapper: any EntityMapper = FormMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    func excute() async throws -> [FieldEntity] {
        do {
            let response = try await repository.fetchForm()
            let controls = response.map { field in return self.map(dto: field) }
            return controls
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }

    func map(dto: FieldDTOEnum) -> FieldEntity {
         let entityMapper = mapper as! FormMapper
        return entityMapper.map(from: dto)!
    }
}
