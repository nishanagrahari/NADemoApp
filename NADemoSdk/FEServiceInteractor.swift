//
//  FEServiceInteractor.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 06/10/23.
//

import Foundation
import Alamofire


extension JSONDecoder {
    
    static var flJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
class FEServiceInteractor {
    
    //MARK: Initialisation
    static let shared = FEServiceInteractor()
    
//    let reachabilityManager = NetworkReachabilityManager()
//    private var previousReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
//
//    let cacheIgnorePaths = [FLAppConfig.shared.getProfileUrl, FLAppConfig.shared.matchmakingUrl, FLAppConfig.shared.gameResultsUrl]
//    var userAgent: String {
//        //Platform/Android Platform-Version/11 App-Name/Frolic-D App-Version/0.0.189 Identifier/live.frolic.app.playstore.debug
//        var bundleID = FLUtils.shared.bundleId
//        if FLAppConfig.shared.appMode == .freeGaming || FLAppConfig.shared.appMode == .singleGame { bundleID = "\(bundleID).lite" }
//        return "Platform/\(FLUtils.shared.deviceOS) Platform-Version/\(FLUtils.shared.deviceOSVersion) App-Name/\(FLUtils.shared.appName) App-Version/\(FLUtils.shared.appVersion) Identifier/\(bundleID)"
//
    
    
   
    
    var baseURLWithVersion: URL { APIRouter.baseURLWithVersion }
    
    
    func request(forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler, enableCache: Bool = true) {
        AF.request(router).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        completion(asJSON, nil)
                        // Handle as previously success
                    } catch {
                        completion(nil, error.localizedDescription)
                        // Here, I like to keep a track of error if it occurs, and also print the response data if possible into String with UTF8 encoding
                        // I can't imagine the number of questions on SO where the error is because the API response simply not being a JSON and we end up asking for that "print", so be sure of it
                        print("Error while decoding response: \(error) from: \(String(data: data, encoding: .utf8) ?? "")")
                        break
                    }
                case .failure(let error):
                print("Error while decoding response: \(error)")
                completion(nil, error.localizedDescription)

                    break
                    // Handle as previously error
                }
        }
        
        
        
        //responseJSON(completionHandler: completion)
        
//        AF.request(router).responseDecodable(of: T.self, decoder: JSONDecoder.flJSONDecoder) { [weak self] (response: DataResponse<T, AFError>) in
//            self?.handleResponse(response: response, forAPI: router, andCompletionHandler: completion)
//        }
    }
    
    
//    private func handleResponse<T: Decodable>(response : DataResponse<T, AFError>, forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler<T>) {
//        let responseCode = response.response?.statusCode
//        if responseCode == 401, let responseData = response.data  {
//                print("401 error found")
//                let parsedData = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String : Any]
//                if let message = parsedData?["message"] as? String {
//                    print("401 error with message \(message)")
//                    completion(response.value, response.error)
//                } else {
//                    print("401 error witout message empty")
//
//                    return
//                }
//
//        }
//        completion(response.value, response.error)
//    }
    
    func requestString<T: Decodable>(forAPI router: APIRouter, withResponseFormat format: T.Type, andCompletionHandler completion: @escaping ((String?) -> ()), enableCache: Bool = true) {
        AF.request(router).responseString { (responseString) in
            completion(responseString.value)
        }
    }
}


protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
    case userAgent = "User-Agent"
    case platform = "X-Platform"
    case clientVersion = "X-Client-Version"
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
    case pdf = "application/pdf"
}

enum RequestParams {
   // case requestBody(_:Codable, _: EncodingType = .snakeCase)
    case requestBodyWithDictionary(_: [String: Any])
//    case urlQuery(_:Codable, _: EncodingType = .snakeCase)
//    case bodyAndUrlParams(body:Codable, url:Codable, _: EncodingType = .snakeCase)
//    case header(_:Codable)
//    case urlReplace(_:[URLReplaceIdentifier : String])
//    case urlReplaceAndParams(replace:[URLReplaceIdentifier : String], params: Codable, _: EncodingType = .snakeCase)
//    case urlReplaceAndBody(replace:[URLReplaceIdentifier : String], body: Codable, _: EncodingType = .snakeCase)
    case none
}

typealias FLServiceTaskCompletionHandler = (Any?, String?) -> Void
typealias FLServiceSuccessBlock = ()->()
typealias FLServiceFailureBlock = (_ errorMessage: String?)->()
typealias FLServiceNetworkIssueBlock = ()->()
