//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormBuildUseCaseProtocol{
    func excute() async throws -> [FieldDTOEnum]
}


class FormBuildUseCase: FormBuildUseCaseProtocol {


    private let repository: FormBuildRepository
    private let mapper: any EntityMapper


    init(repository: FormBuildRepository = LocalFormRepository(), mapper: any EntityMapper = FormMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    func excute() async throws -> [FieldDTOEnum] {
        return try await repository.fetchForm()
    }

//    func excute(_ fields: [Field]) -> [ControlType] {
//        return fields.compactMap { field -> ControlType? in
//            return map(dto: field)
//
//        }
//    }


    func map(dto: Field) -> ControlType? {
        if let entityMapper = mapper as? FormMapper {
            return entityMapper.map(from: dto)
        }
        return nil
    }
}
