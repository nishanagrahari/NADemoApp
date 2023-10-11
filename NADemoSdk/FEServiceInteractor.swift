//
//  FEServiceInteractor.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 06/10/23.
//

import Foundation
import Alamofire

extension Encodable {
    
    func convertToDictionary() throws -> [String: Any] {
        let data:Data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
public protocol FLServiceInteractorProtocol {
    func request(forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler)
}
class FEServiceInteractor: FLServiceInteractorProtocol {
    
   // var baseURLWithVersion: URL { APIRouter.baseURLWithVersion }
    
    
    func request(forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler) {
        AF.request(router).responseData { response in
            if response.response?.statusCode == 401 {
                self.refreshToken(forAPI: router, andCompletionHandler: completion)
            }  else {
                switch response.result {
                    case .success(let data):
                        do {
                            let asJSON = try JSONSerialization.jsonObject(with: data)
                            if let httpStatusCode = response.response?.statusCode,
                               (200..<300).contains(httpStatusCode) {
                                completion(asJSON, nil)
                            } else {
                                completion(nil, asJSON)
                            }
                            // Handle as previously success
                        } catch {
                            completion(nil, error.localizedDescription)
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

        }
    }
    
    
    private func refreshToken(forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler) {
        let session = FEUserSession.getSession()
        let request = FERefreshTokenRequest(token: session?.refreshToken, accessCookie: session?.accessToken)
        self.request(forAPI: .refreshToken(request)) { response, error in
            self.request(forAPI: router, andCompletionHandler: completion)
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
    case platform = "X-Platform"
    case clientVersion = "X-Client-Version"
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
    case pdf = "application/pdf"
}

enum RequestParams {
     case requestBody(_:Codable)
    case requestBodyWithDictionary(_: [String: Any])
    case urlReplace(_:[URLReplaceIdentifier : String])
    case none
}

public typealias FLServiceTaskCompletionHandler = (_ response: Any?, _ error: Any?) -> Void
public typealias FLServiceSuccessBlock = ()->()
public typealias FLServiceFailureBlock = (_ errorMessage: Any?)->()
public typealias FLServiceNetworkIssueBlock = ()->()


public enum URLReplaceIdentifier: String {
    case userId = ":userId"
    case subscriptionId = ":subscriptionId"
   
}

struct FLAppConfig {
    
    var appConfigMode: FLAppConfigurationMode = .debug
    static var shared = FLAppConfig(appConfigMode: .debug)
    
    init(appConfigMode: FLAppConfigurationMode) {
        self.appConfigMode = appConfigMode
    }
    var hostName: String {
        switch appConfigMode {
            case .debug: return "engage.frolicz0.de"
            case .uat: return "engage.frolicz0.de"
            case .release: return "engage.frolic.live"
        }
    }
    private var apiHostName: String { return "\(hostName)" }
    
    var apiDomainUrl: String { return "https://\(apiHostName)" }
    var apiBaseUrl: URL { URL(string: "\(apiDomainUrl)/service/application/app")! }
   
    // User Subscription
    var getUserSubscriptionDetail = "subscriptions/users/:userId"
    var addUserSubscription = "subscriptions/:subscriptionId/users/:userId/payment"
    var getSubscriptionFeature = "subscriptions/:subscriptionId/features"
    var getUserSubscriptionFeature = "subscriptions/users/:userId/features"
    var renewUserSubscription = "subscriptions/users/:userId/renew"
    var upgradeUserSubscriptionPlan = "subscriptions/users/:userId/upgrade"


    // USer Detail
    var userDetail = "users/:userId"
    var userRegister = "users/register"
    var getUserAccesToken = "auth/token"
    var refreshAccesToken = "auth/token"

// User Activity
    var getuserActivityDetail = "activities/:activityCode/users/:userId"
    var publishuserActivity = "activities/:activityCode/users/:userId"
    var getUserAllPreviousActivity = "activities/users/:userId"

        
}


enum FLAppConfigurationMode: Codable {
    case debug
    case uat
    case release
}
