//
//  FEAPIRouter.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 06/10/23.
//

import Foundation
import Alamofire
public enum APIRouter: APIConfiguration {
    
   // case login(_ request: String)
    case authLogin(_ apiKey: String, _ userId: String)
    case userRegister(_ name: String, _ identifire: String)
    case refreshToken(_ request: FERefreshTokenRequest)
    case userSubscriptionDetail(_ urlReplace: [URLReplaceIdentifier : String])
    case addUserSubscription(_ urlReplace: [URLReplaceIdentifier : String])
    case subscriptionFeature(_ urlReplace: [URLReplaceIdentifier : String])
    case userSubscriptionFeature(_ urlReplace: [URLReplaceIdentifier : String])
    case renewSubscription(_ urlReplace: [URLReplaceIdentifier : String])
    case upgradePlan(_ urlReplace: [URLReplaceIdentifier : String])
    case userDetail(_ urlReplace: [URLReplaceIdentifier : String])
    case userActivityDetail(_ urlReplace: [URLReplaceIdentifier : String])
    case publishUserActivity(_ urlReplace: [URLReplaceIdentifier : String])
    case getUserAllPreviousActivity(_ urlReplace: [URLReplaceIdentifier : String])

    static var baseURLWithVersion: URL { FLAppConfig.shared.apiBaseUrl.appendingPathComponent(version) }
    
    
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .userRegister, .refreshToken, .authLogin:
            return .post
        case .userSubscriptionDetail, .addUserSubscription, .subscriptionFeature, .userSubscriptionFeature, .renewSubscription, .upgradePlan, .userDetail:
            return .get
        case .userActivityDetail, .publishUserActivity, .getUserAllPreviousActivity:
            return .get
       
      
        }
    }
    
    
    // MARK: - Parameters
    var parameters: RequestParams {
        switch self {
        case .userRegister(let appkey, let userId):
            let request = FEAuthLoginRequest(apiKey: appkey, userIdentifier: userId)
            return .requestBody(request)
        case .refreshToken(let request):
            return .requestBody(request)
        case .authLogin(let appkey, let userId):
            let request = FEAuthLoginRequest(apiKey: appkey, userIdentifier: userId)
            return .requestBody(request)
        case .userSubscriptionDetail(let urlReplace):
            return .urlReplace(urlReplace)
        case .addUserSubscription(let urlReplace):
            return .urlReplace(urlReplace)
        case .subscriptionFeature(let urlReplace):
            return .urlReplace(urlReplace)
        case .userSubscriptionFeature(let urlReplace):
            return .urlReplace(urlReplace)
        case .renewSubscription(let urlReplace):
            return .urlReplace(urlReplace)
        case .upgradePlan(let urlReplace):
            return .urlReplace(urlReplace)
        case .userDetail(let urlReplace):
            return .urlReplace(urlReplace)
        case .userActivityDetail(let urlReplace):
              return .urlReplace(urlReplace)
        case .publishUserActivity(let urlReplace):
            return .urlReplace(urlReplace)
        case .getUserAllPreviousActivity(let urlReplace):
            return .urlReplace(urlReplace)
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            // force update
        case .refreshToken:
            return FLAppConfig.shared.refreshAccesToken
        case .authLogin:
            return FLAppConfig.shared.getUserAccesToken
        case .userRegister:
            return FLAppConfig.shared.userRegister

        case .userSubscriptionDetail:
            return FLAppConfig.shared.getUserSubscriptionDetail

        case .addUserSubscription:
            return FLAppConfig.shared.addUserSubscription

        case .subscriptionFeature:
            return FLAppConfig.shared.getSubscriptionFeature

        case .userSubscriptionFeature:
            return FLAppConfig.shared.getUserSubscriptionFeature

        case .renewSubscription:
            return FLAppConfig.shared.renewUserSubscription

        case .upgradePlan:
            return FLAppConfig.shared.upgradeUserSubscriptionPlan

        case .userDetail:
            return FLAppConfig.shared.userDetail

        case .userActivityDetail:
            return FLAppConfig.shared.getuserActivityDetail

        case .publishUserActivity:
            return FLAppConfig.shared.publishuserActivity

        case .getUserAllPreviousActivity:
            return FLAppConfig.shared.getUserAllPreviousActivity

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
        case .authLogin, .refreshToken:
         break
        default:
            if let userToken = FEUserSession.getSession()?.accessToken {
                let token = "bearer\(userToken)"
                urlRequest.setValue(token, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            }
        }
        
        urlRequest.url = url.appendingPathComponent(path)
        //HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        //Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        
        // Parameters
        switch parameters {
        case .requestBody(let request):
            let params = try request.convertToDictionary()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .requestBodyWithDictionary(let dictionary):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        case .urlReplace(let replacements):
            var paramPath = path
            paramPath.replaceURLParameters(withParameters: replacements)
            urlRequest.url = url.appendingPathComponent(paramPath)
        case .none:
            break
        }
        return urlRequest
    }
}


extension String {
    mutating func replaceURLParameters(withParameters parameters:[URLReplaceIdentifier : String]) {
        for (key,value) in parameters { self = self.replacingOccurrences(of: key.rawValue, with: value) }
    }
}
