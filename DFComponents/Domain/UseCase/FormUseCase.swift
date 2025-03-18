//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormBuildUseCaseProtocol {
    func excute() async throws -> FormEntity
    func map(dto: Schema) -> [PageModel]
    func map(dto: Warnings) -> WarningsEntity
}

class FormBuildUseCase: FormBuildUseCaseProtocol {

    private let repository: FormBuildRepository
    private let mapper: any EntityMapper

    init(repository: FormBuildRepository = LocalFormRepository(),
         mapper: any EntityMapper = FormMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    func excute() async throws -> FormEntity {
        do {
            let response = try await repository.fetchForm()
            let pages: [PageModel] = map(dto: response)
            let warnings = map(dto: response.warnings) // Map warnings
            return FormEntity(pages: pages, rules: response.rules ?? [], warnings: warnings)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return FormEntity(pages: [], rules: [], warnings: nil)
        }
    }

    func map(dto: Schema) -> [PageModel] {
        let entityMapper = mapper as! FormMapper
        return entityMapper.map(from: dto)
    }

    //MARK: - Map Warning
    func map(dto: Warnings) -> WarningsEntity {
        let entityMapper = mapper as! FormMapper
        return entityMapper.map(from: dto)
    }


}
