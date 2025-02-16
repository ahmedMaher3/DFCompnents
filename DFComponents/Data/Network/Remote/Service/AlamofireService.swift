//
//  AlamofireService.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 06/14/20.
//  Copyright © 2020 MaherOrganization. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireService: EndpointExecuter {

    // 🔹 Standard session (without caching)
    private let manager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData // ✅ Updated to `reloadIgnoringLocalCacheData`
        return Session(configuration: configuration)
    }()

    // 🔹 Background session (for background tasks)
    private let backgroundManager: Session = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        return Session(configuration: configuration)
    }()

    //private var activeRequests: [FileVersionType: UploadRequest] = [:]

    func execute(_ endpoint: Endpoint) async throws -> NetworkServiceResponse {
        let request =  self.request(by: endpoint) 

        return try await withCheckedThrowingContinuation { continuation in
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    let networkResponse = NetworkServiceResponse(
                        data: data,
                        statusCode: response.response?.statusCode,
                        headers: response.response?.allHeaderFields
                    )
                    continuation.resume(returning: networkResponse)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }


    private func request(by endpoint: Endpoint)  -> DataRequest {

        print("ℹ️ Endpoint URL : \(endpoint.service.url + endpoint.urlPrefix)")
        print("ℹ️ Method : \(endpoint.method.alamofireEndpoint)")
        print("ℹ️ Parameters : \(endpoint.parameters)")
        print("ℹ️ Headers : \(concatenateHeaders(for: endpoint))")

        
        return manager.request(endpoint.service.url + endpoint.urlPrefix,
                               method: endpoint.method.alamofireEndpoint,
                               parameters: endpoint.parameters,
                               encoding: endpoint.encoding.alamofireEncoding,
                               headers: [])
    }

//    func uploadMultipart(_ endpoint: Endpoint,progressCallBack: @escaping (Double,FileVersionType) -> ()) -> Promise<NetworkServiceResponse> {
//        return Promise<NetworkServiceResponse>(on: .global()) { fulfill, reject in
//            self.upload(by: endpoint, completionHandler: { (response) in
//                let fileVersionType = endpoint.parameters["fileVersion"] as? FileVersionType ?? .english
//                switch response {
//                case .success(let upload, _,_):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("💛💛💛\(progress.fractionCompleted)")
//                        progressCallBack(progress.fractionCompleted, fileVersionType)
//                    })
//                    self.activeRequests[fileVersionType] = upload
//                    upload.response { response in
//                        fulfill(NetworkServiceResponse(data: response.data!,
//                                                       statusCode: response.response?.statusCode,
//                                                       headers: response.response?.allHeaderFields))
//                    }
//                case .failure(let error):
//                    print("Enter Failur ❤️")
//                    reject(error)
//                }
//            })
//        }
//    }

//    private func upload(by endpoint: Endpoint, completionHandler: @escaping (SessionManager.MultipartFormDataEncodingResult) -> Void ) {
//        // Don't forget to set Date().getCurrentSecond()
//        var params = [String: Any]()
//        for (key, value) in endpoint.parameters {
//            if value is String {
//                params[key] = (value as?String)?.cerqel_replacedArabicDigitsWithEnglish
//            }
//            else{
//                params[key] = value
//            }
//        }
//        print("ℹ️ url : \(endpoint.service.url + endpoint.urlPrefix)")
//        print("ℹ️ Method : \(endpoint.method.alamofireEndpoint)")
//        print("ℹ️ Parameters : \(params.filter{$0.value as?String != "" && $0.value as?Int != 0})")
//        print("ℹ️ Headers : \(concatenateHeaders(for: endpoint))")
//
//        Alamofire.upload(multipartFormData: { MultipartFormData in
//            for (key, value) in params.filter({($0.value as? String) != ""
//            }) {
//
//                if  key == "files"{
//                 
//                    let file = value as! FileRequest
//
//                    let item = MultiPartModel(data: file.date ,
//                                              fileName: "file\(Date()).\(file.extenstion.rawValue)",
//                                              //fileName: file.fileName,
//                                              mimeType: file.extenstion == .PNG ? "image/\(file.extenstion.rawValue)" : "application/\(file.extenstion.rawValue)",
//                                              keyName: key)
//                
//                    MultipartFormData.append(item.data, withName: key, fileName: item.fileName, mimeType: item.mimeType)
//                }
//             
//                else{
//                    MultipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//
//            }
//        },
//                       usingThreshold: UInt64.init(),
//                       to: endpoint.service.url + endpoint.urlPrefix,
//                       method: endpoint.method.alamofireEndpoint,
//                       headers: concatenateHeaders(for: endpoint),
//                       encodingCompletion: { result in
//                        completionHandler(result)
//        })
//    }
    
//    private func download(_ filesUrl: [String], completionHandler: @escaping (URL) -> Void ) {
//       
//        for fileUrl in filesUrl {
//            print("ℹ️ url : \(fileUrl)")
//            guard let fileURL = URL(string: fileUrl) else { return  }
//            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
//                let fileURL = documentsURL.appendingPathComponent("file.pdf")
//                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//            }
//            Alamofire.download(
//                fileURL,
//                method: .get,
//                parameters: Parameters.init(),
//                encoding: JSONEncoding.default,
//                headers: nil,
//                to: destination).downloadProgress(closure: { (progress) in
//                    let progressValue = progress.fractionCompleted * 100
//                    print("🩷🩷🩷\(progressValue)")
//                }).response(completionHandler: { (DefaultDownloadResponse) in
//                     let localFileUrl = DefaultDownloadResponse.destinationURL?.absoluteString
//                     let FileUrl = DefaultDownloadResponse.destinationURL
//
//                    if(DefaultDownloadResponse.response?.statusCode == 200) {
//                        completionHandler(FileUrl!)
//                    }
//                })
//        }
//       
//     
//    }
    
//    func downloadFile(_ filesUrl: [String]) -> Promise<URL> {
//          return Promise<URL>(on: .global()) { fulfill, reject in
//            //  for file in filesUrl {
//                  self.download(filesUrl, completionHandler: { (url) in
//                      fulfill(url)
//                  })
//           //   }
//           
//          }
//    }
    
//    func cancelUpload(_ fileVersionType: FileVersionType) {
//            if let request = activeRequests[fileVersionType] {
//                request.cancel()
//                activeRequests[fileVersionType] = nil
//            }
//        }
    
    private func concatenateHeaders(for endpoint: Endpoint) -> [String: String] {
        var headers = endpoint.headers.filter{$0.value != ""}
//        headers.updateValue(Localization.currentAppleLanguage(), forKey: "Accept-Language")
//        headers.updateValue(Localization.currentAppleLanguage(), forKey: "language")
       // headers.updateValue("application/json", forKey: "Content-Type")
      
        for (key, value) in endpoint.auth.tokenHeader {
            headers.updateValue(value, forKey: key)
            
        }
        for (key, value) in endpoint.auth.clientHeader {
            headers.updateValue(value, forKey: key)
            headers.updateValue("iOS", forKey: "Platform")
          //  headers.updateValue(AuthManager.shared.tenant?.tenantId ?? "", forKey: "TenantId")
        }
        return headers
    }

//    private func uploadFileNotificationCenter(progress: Double,fileVersionType: FileVersionType){
//      
//        let progressValue: [String: Any] = ["progress": progress,"fileVersionType": fileVersionType]
//       
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inProgress"), object: nil, userInfo: progressValue)
//    }
}

extension EndpointEncoding {
    var alamofireEncoding: ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .query: return URLEncoding.queryString
        }
    }
}

extension EndpointMethod {
    var alamofireEndpoint: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .delete: return .delete
        case .put: return .put
        case .patch: return .patch
        }
    }
}


extension String {
    var containsScriptTag : Bool {
        // Regex pattern to find text enclosed in <>
        let pattern = "<[^>]*>"

        // Create a regex object
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        // Check if there are any matches
        let matches = regex?.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        // Return true if there are matches
        return matches ?? 0 > 0
    }

    var sanitized: String {
           // Regex pattern to find text enclosed in <>
           let pattern = "<[^>]*>"

           // Create a regex object
           let regex = try? NSRegularExpression(pattern: pattern, options: [])

           // Replace all matches with an empty string
           let sanitizedString = regex?.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "") ?? self

           // Return the modified string
           return sanitizedString
       }
}

enum RequestError: Error {
    case invalidParameter(String)
}
