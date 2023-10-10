//
//  FEAPIRouter.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 06/10/23.
//

import Foundation
import Alamofire
public enum APIRouter: APIConfiguration {
    
    //Login
//    case getOTP(_ request: FLLoginGetOTPRequest)
//    case getEmailOTP(_ request: FLEmailGetOTPRequest)
//    case verifyOTP(_ request: FLEmailAuthRequest)
    
    case login(_ request: String)
    case authLogin(_ apiKey: String)
  //  case refreshAuth(_ authToken: String)
    case refreshToken(_ request: FERefreshTokenRequest)
    //MARK: Base URL
    static var baseURLWithVersion: URL {
        let baseUrl = URL(string: "https://engage.frolicz0.de/service/application/app")!
        return baseUrl.appendingPathComponent(version)
    }
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login, .refreshToken, .authLogin:
            return .post
        }
    }
    
    
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        case .login:
            return .none
        case .refreshToken(let request):
            return .header(request)
        case .authLogin(let request):
            return .header(request)
            
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            // force update
        case .refreshToken:
            return ""
        case .login, .authLogin:
            return "FLAppConfig.shared.forceUpdate"
            //Login
       
        }
    }
    
    //MARK: Version
    static var version: String { return "v1/" }
    static var version2: String { return "v2/" }

    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        var url = APIRouter.baseURLWithVersion
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .login, .authLogin, .refreshToken:
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
        
        
        // Parameters
        switch parameters {
            //            case .requestBody(let request, let encodingType):
            //            let params = try request.convertToDictionary(encoder: encodingType)
            //            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            //            reqData = params
        case .requestBodyWithDictionary(let dictionary):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        case .header(let request):
            let params = try request.convertToDictionary()
            params.forEach({
                urlRequest.setValue($0.value as? String, forHTTPHeaderField: $0.key)
            })
        case .none:
            break
        }
        return urlRequest
    }
}
