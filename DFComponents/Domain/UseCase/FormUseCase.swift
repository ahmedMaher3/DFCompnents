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
            let header: ClassicPageHeader? = response.campaign?.header
            let footer: ClassicPageFooter? = response.campaign?.footer
            let welcomeData: CardWelcomeData? = response.campaign?.welcome
            let pages: [PageModel] = map(dto: response)
            let warnings = map(dto: response.warnings) // Map warnings
            return FormEntity(
                pages: pages,
                rules: response.rules ?? [],
                warnings: warnings,
                header: header,
                footer: footer,
                welcome: welcomeData
            )
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return FormEntity(pages: [], rules: [], warnings: nil, header: nil, footer: nil, welcome: nil)
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
