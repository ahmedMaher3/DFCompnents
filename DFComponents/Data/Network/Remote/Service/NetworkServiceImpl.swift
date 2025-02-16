//
//  NetworkServiceImpl.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MaherOrganization. All rights reserved.
//

import Foundation

protocol EndpointExecuter {
    func execute(_ endpoint: Endpoint) async throws -> NetworkServiceResponse
    //func cancelUpload(_ fileVersionType: FileVersionType) -> Void
    //    func uploadMultipart(_ endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<NetworkServiceResponse>
    //    func downloadFile(_ filesUrl: [String]) -> Promise<URL>
}

protocol ReachabilityProtocol {
    // func connection() -> Reachability.Connection?
}

class NetworkServiceImpl: Network {


    var endpointExecuter: EndpointExecuter = AlamofireService()
    var reachability: ReachabilityProtocol = ReachabilityImpl()

    func callModel<Model: Codable>( endpoint: Endpoint)  async throws -> Model {
        do {
            let data = try await self.call(endpoint: endpoint)
            //  print("Response Data 🤪🤪🤪🤪  \(JSON(data))")
            let obj = try JSONDecoder().decode(Model.self, from: data)
            return obj

        }
        catch {
            throw  error is ServerError ? error : self.networkFail()
        }



    }

    //    func callModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint) -> Promise<Model> {
    //        return Promise<Model>(on: .main) { fulfill, reject in
    //            self.call(endpoint: endpoint)
    //                .then({ (data) in
    //                    do {
    //                        //  print("Response Data 🤪🤪🤪🤪  \(JSON(data))")
    //                        let obj = try JSONDecoder().decode(Model.self, from: data)
    //                        fulfill(obj)
    //                    } catch let jsonError {
    //                        print("JsonSerlization Error 😱😱😱😱😱 \(jsonError.localizedDescription)")
    //                        reject(FailToMapResponseError(data: data))
    //                    }
    //
    //                })
    //                .catch({ (error) in
    //                    if let error  = error as? ServerError, error.status == 401 {
    //                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
    //                            TokenManager.shared.refreshToken {
    //                                // Retry the request after token refresh
    //                                self.callModel(model, endpoint: endpoint)
    //                                                            .then(fulfill)
    //                                                            .catch(reject)
    //                        }
    //                    }
    //                    else {
    //                        reject(error)
    //                    }
    //                })
    //        }
    //    }


    //
    //    func uploadModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Model> {
    //        return Promise<Model>(on: .main) { fulfill, reject in
    //            self.upload(endpoint: endpoint, progressCallBack: progressCallBack)
    //                .then({ (data) in
    //                    guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
    //                        reject(FailToMapResponseError(data: data))
    //                        return
    //                    }
    //                    print("🎉🎉 After Codable : \(response)")
    //                    fulfill(response)})
    //                .catch({ (error) in
    //                    if let error  = error as? ServerError, error.status == 401 {
    //                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
    //                            TokenManager.shared.refreshToken {
    //                                // Retry the request after token refresh
    //                                self.uploadModel(model, endpoint: endpoint, progressCallBack: progressCallBack)
    //                                                            .then(fulfill)
    //                                                            .catch(reject)
    //
    //                        }
    //                    }
    //                    else {
    //                        reject(error)
    //                    }
    //
    //                })
    //        }
    //    }

    //    func downloadModel( filesUrl: [String]) -> Promise<URL> {
    //        return Promise<URL>(on: .main) { fulfill, reject in
    //            self.download(filesUrl)
    //                .then({ (fileUrl) in
    //                    fulfill(fileUrl)})
    //                .catch({ (error) in
    //                    if let error  = error as? ServerError, error.status == 401 {
    //                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
    //                            TokenManager.shared.refreshToken {
    //                                // Retry the request after token refresh
    //                                self.downloadModel(filesUrl: filesUrl)
    //                                                            .then(fulfill)
    //                                                            .catch(reject)
    //
    //                        }
    //                    }
    //                    else {
    //                        reject(error)
    //                    }
    //
    //
    //                })
    //        }
    //    }

    func call(endpoint: Endpoint) async throws -> Data {
        let response = try await fetchNetworkResponse(endpoint)
        return try processResponse(response)

//        do {
//            var response = try await endpointExecuter.execute(endpoint)
//            var data = try self.networkSuccess(data: response.data, statusCode: response.statusCode)
//            //            let header = response.headers as? [String: Any]
//            //            let jsonData = try JSONSerialization.data(withJSONObject: header, options: [])
//            //            let decoder = JSONDecoder()
//            //            let headerResponse = try decoder.decode(HeaderResponse.self, from: jsonData)
//            return data
//
//        }
//        catch {
//            throw  error is ServerError ? error : self.networkFail()
//
//        }

    }

    // 🔹 Handles only network errors
    private func fetchNetworkResponse(_ endpoint: Endpoint) async throws -> NetworkServiceResponse {
        do {
            return try await endpointExecuter.execute(endpoint)
        } catch let error as ServerError {
            throw error
        } catch {
            throw  (error is ServerError) ? ServerError() : self.networkFail()
        }
    }

    // 🔹 Handles only data processing errors
    private func processResponse(_ response: NetworkServiceResponse) throws -> Data {
        do {
            return try self.networkSuccess(data: response.data, statusCode: response.statusCode)
        } catch {
             throw  error
        }
    }

    //    func call(endpoint: Endpoint) -> Promise<Data> {
    //        return Promise<Data>(on: .main) { fulfill, reject in
    //            self.endpointExecuter.execute(endpoint)
    //                .then({ (response) in
    //                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
    //                        let header = response.headers as? [String: Any]
    //                        let jsonData = try JSONSerialization.data(withJSONObject: header, options: [])
    //                        let decoder = JSONDecoder()
    //                        let headerResponse = try decoder.decode(HeaderResponse.self, from: jsonData)
    //                        fulfill(data)
    //                    }).catch({ (error) in
    //                         reject(error)
    //                    })
    //                })
    //                .catch({ (error) in
    //
    //                    if error is ServerError {
    //                        reject(error)
    //                    }
    //                    else {
    //                        reject(self.networkFail())
    //                    }
    //                })
    //        }
    //    }
    //
    //    private func upload(endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Data> {
    //        return Promise<Data>(on: .main) { fulfill, reject in
    //            self.endpointExecuter.uploadMultipart(endpoint, progressCallBack: progressCallBack)
    //                .then({ (response) in
    //                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
    //                        fulfill(data)
    //                    }).catch({ (error) in
    //                        reject(error)
    //                    })
    //                }).catch({ _ in
    //                    reject(self.networkFail())
    //                })
    //        }
    //    }

    //    private func download(_ filesUrl: [String]) -> Promise<URL> {
    //        return Promise<URL>(on: .main) { fulfill, reject in
    //            self.endpointExecuter.downloadFile(filesUrl)
    //                .then({ (response) in
    //
    //                    fulfill(response)
    //                }).catch({ error in
    //                    reject(self.networkFail())
    //                })
    //
    //
    //        }
    //    }

    //    func cancelUpload(_ fileVersionType: FileVersionType) {
    //        self.endpointExecuter.cancelUpload(fileVersionType)
    //    }
    //

    private func networkSuccess(data: Data, statusCode: Int?) throws -> Data {
        // return Promise<Data>(on: .main) { fulfill, reject in
        print("⬆️⬆️ Status Code : \(String(describing: statusCode ?? 0))")
        //  print("⬆️⬆️ Endpoint Respose : \(JSON(data))")

        if (200...299).contains(statusCode ?? 0) {
            return data

        } else {
            guard let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
                throw (ServerError(status: statusCode!))
            }
            throw(error)


        }
        //  }
    }



    //    private func networkSuccess(data: Data, statusCode: Int?) -> Promise<Data> {
    //        return Promise<Data>(on: .main) { fulfill, reject in
    //            print("⬆️⬆️ Status Code : \(String(describing: statusCode ?? 0))")
    //            print("⬆️⬆️ Endpoint Respose : \(JSON(data))")
    //
    //            if (200...299).contains(statusCode ?? 0) {
    //                fulfill(data)
    //            } else {
    //                guard let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
    //                    reject(ServerError(status: statusCode!))
    //                    return
    //                }
    //                reject(error)
    //                if  statusCode == 401 {
    //                   // AuthManager.shared.unauthorizedFlag.accept(true)
    //                }
    //
    //            }
    //        }
    //    }

    private func saveHeaders( _ header: HeaderResponse) {
        UserAuthoriationHandler().setAuthManually(authToken: header.token ?? "")
        UserAuthoriationHandler().setUidManually(uid: header.uid ?? "")    }

    private func networkFail() -> Error {
        return isConnectedToInternet ? FailToCallNetworkError() : NoInternetConnectionError()
    }

    private var isConnectedToInternet: Bool {
        // return reachability.connection() != Reachability.Connection.none
        return true
    }

    //    private func mapJsonToModel<Model: Codable>(_ model: Model.Type, from data: Data) -> Promise<Model>{
    //        return Promise<Model>(on: .main) { fulfill, reject in
    //            guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
    //                return  reject(FailToMapResponseError(data: data))
    //            }
    //            return fulfill(response)
    //        }
    //    }



}

struct NetworkServiceResponse {
    var data: Data
    var statusCode: Int?
    var headers: [AnyHashable: Any]?
}

class ReachabilityImpl: ReachabilityProtocol {

    //    func connection() -> Reachability.Connection? {
    //        return Reachability()?.connection
    //    }
}

struct HeaderResponse: Codable {
    var token: String?
    var client: String?
    var uid: String?

    enum CodingKeys: String, CodingKey {
        case token = "access-token"
        case client, uid
    }
}
