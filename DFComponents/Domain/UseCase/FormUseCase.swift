//
//  FormUseCase.swift
//  DFComponents
//
//  Created by ahmed maher on 19/02/2025.
//

import Foundation

protocol FormUseCaseProtocol{
    func excute() -> [ControlType]
}


class FormUseCase: FormUseCaseProtocol {



    //    private let repository: AboutUsRepo
    private let mapper: any EntityMapper
    //
    //    init(repository: AboutUsRepo = AboutUsRepoImpl(), mapper: any EntityMapper = AboutUsMapper()) {
    //        self.repository = repository
    //        self.mapper = mapper
    //    }

    init( mapper: any EntityMapper = FormMapper()) {
        self.mapper = mapper
    }

    //    func excute() -> Promise<BaseResponseWithoutCodable<AboutUsEntity>> {
    //        return Promise<BaseResponseWithoutCodable<AboutUsEntity>> { fulfill, reject in
    //            self.repository.getAboutUs().then { response in
    //                let dtoResponse = response.result.data
    //                let mappedEntities = self.map(dto: dtoResponse)
    //                let result = ResultWithoutCodable(totalCount: response.result.totalCount, data: mappedEntities, pagesCount: response.result.pagesCount)
    //                let baseResponse = BaseResponseWithoutCodable(message: response.message, result: result)
    //                fulfill(baseResponse)
    //            }.catch { error in
    //                reject (error)
    //            }
    //
    //        }
    //    }

    func excute() -> [ControlType] {
        return []
    }

    func excute(_ fields: [Field]) -> [ControlType] {
        return fields.compactMap { field -> ControlType? in
            return map(dto: field)

        }
    }

    
    func map(dto: Field) -> ControlType? {
        if let entityMapper = mapper as? FormMapper {
            return entityMapper.map(from: dto)
        }
        return nil
    }
}
