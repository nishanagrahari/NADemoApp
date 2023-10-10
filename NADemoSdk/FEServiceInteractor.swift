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
            if response.response?.statusCode == 404 {
                self.refreshToken(forAPI: router, andCompletionHandler: completion)
            } else {
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

        }
    }
    
    
    private func refreshToken(forAPI router: APIRouter, andCompletionHandler completion: @escaping FLServiceTaskCompletionHandler) {
        let session = FEUserSession.getSession()
        let request = FERefreshTokenRequest(token: session?.refreshToken, accessCookie: session?.accessToken)
        self.request(forAPI: .refreshToken(request)) { response, error in
            self.request(forAPI: router, andCompletionHandler: completion)
        }
    }

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
    case header(_:Codable)
    //    case urlReplace(_:[URLReplaceIdentifier : String])
    //    case urlReplaceAndParams(replace:[URLReplaceIdentifier : String], params: Codable, _: EncodingType = .snakeCase)
    //    case urlReplaceAndBody(replace:[URLReplaceIdentifier : String], body: Codable, _: EncodingType = .snakeCase)
    case none
}

public typealias FLServiceTaskCompletionHandler = (Any?, String?) -> Void
public typealias FLServiceSuccessBlock = ()->()
public typealias FLServiceFailureBlock = (_ errorMessage: String?)->()
public typealias FLServiceNetworkIssueBlock = ()->()
