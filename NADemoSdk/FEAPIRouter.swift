//
//  FEAPIRouter.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 06/10/23.
//

import Foundation
import Alamofire
enum APIRouter: APIConfiguration {
    
    //Login
//    case getOTP(_ request: FLLoginGetOTPRequest)
//    case getEmailOTP(_ request: FLEmailGetOTPRequest)
//    case verifyOTP(_ request: FLEmailAuthRequest)
    
    case login(_ request: String)
   
    
    //MARK: Base URL
    static var baseURLWithVersion: URL {
        let baseUrl = URL(string: "")!
        return baseUrl.appendingPathComponent(version)
    }
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
       
        }
    }
    
    
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
            // force update
        case .login:
            return .none
            
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            // force update
        case .login:
            return "FLAppConfig.shared.forceUpdate"
            //Login
       
        }
    }
    
    //MARK: Version
    static var version: String { return "v1/" }
    static var version2: String { return "v2/" }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url = APIRouter.baseURLWithVersion
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .login:
            url = APIRouter.baseURLWithVersion
            urlRequest = URLRequest(url: url.appendingPathComponent(path))

       // default:
          //  urlRequest.setValue(FLServiceInteractor.shared.userAgent, forHTTPHeaderField: HTTPHeaderField.userAgent.rawValue)
        }
        
        urlRequest.url = url.appendingPathComponent(path)
        
        //HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        //Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("true", forHTTPHeaderField: "x-ddebbugg")
        
        var reqData: [String: Any]?
        
        // Parameters
        switch parameters {
//            case .requestBody(let request, let encodingType):
//            let params = try request.convertToDictionary(encoder: encodingType)
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
//            reqData = params
        case .requestBodyWithDictionary(let dictionary):
            let params = dictionary
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            reqData = params
     //   case .urlQuery(let request, let encodingType):
//            let params = try request.convertToDictionary(encoder: encodingType)
//            let queryParams = params.map { pair  in
//                return URLQueryItem(name: pair.key, value: "\(pair.value)")
//            }.sorted(by: {($0 as URLQueryItem).name < ($1 as URLQueryItem).name})
//            var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
//            components?.queryItems = queryParams
//            urlRequest.url = components?.url
        case .none:
            break
//        case .bodyAndUrlParams(let bodyReq, let urlReq, let encodingType):
//                    let paramsBody = try bodyReq.convertToDictionary(encoder: encodingType)
//                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: paramsBody, options: [])
//                    reqData = paramsBody
//                    let paramsQuery = try urlReq.convertToDictionary(encoder: encodingType)
//                    let queryParams = paramsQuery.map { pair in
//                        return URLQueryItem(name: pair.key, value: "\(pair.value)")
//                    }.sorted(by: {($0 as URLQueryItem).name < ($1 as URLQueryItem).name})
//
//                    var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
//                    components?.queryItems = queryParams
//                    urlRequest.url = components?.url
//        case .header(let request):
//            let params = try request.dictionaryWithoutSnakeCase()
//            params.forEach({
//                urlRequest.setValue($0.value as? String, forHTTPHeaderField: $0.key)
//            })
//        case .urlReplace(let replacements):
//            var paramPath = path
//            paramPath.replaceURLParameters(withParameters: replacements)
//            urlRequest.url = url.appendingPathComponent(paramPath)
//        case .urlReplaceAndParams(let replacements, let queryParams, let encodingType):
//            var replacedPath = path
//            replacedPath.replaceURLParameters(withParameters: replacements)
//            let paramsQuery = try queryParams.convertToDictionary(encoder: encodingType)
//            let queryParams = paramsQuery.map { pair in
//                return URLQueryItem(name: pair.key, value: "\(pair.value)")
//            }.sorted(by: {($0 as URLQueryItem).name < ($1 as URLQueryItem).name})
//            var components = URLComponents(string:url.appendingPathComponent(replacedPath).absoluteString)
//            components?.queryItems = queryParams
//            urlRequest.url = components?.url
//        case .urlReplaceAndBody(replace: let replacements, body: let body, let encodingType):
//            var paramPath = path
//            paramPath.replaceURLParameters(withParameters: replacements)
//            urlRequest.url = url.appendingPathComponent(paramPath)
//            let requestBody = try body.convertToDictionary(encoder: encodingType)
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//            reqData = requestBody
        }
        return urlRequest
       
    }
}
