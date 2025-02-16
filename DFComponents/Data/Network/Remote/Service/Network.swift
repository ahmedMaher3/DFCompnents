//

//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation


//typealias UploadProgrssCallBack = ((Double,FileVersionType)->())
//typealias ProgressCallback = (Double) -> Void

protocol Network {
    //func call(endpoint: Endpoint) -> Promise<Data>
    func callModel<Model: Codable>( endpoint: Endpoint) async throws -> Model
//    func uploadModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Model>
//    func downloadModel( filesUrl: [String]) -> Promise<URL>
//    func cancelUpload(_ fileVersionType: FileVersionType) -> Void
}
