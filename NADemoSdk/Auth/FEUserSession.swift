//
//  FEUserSession.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 09/10/23.
//

import Foundation

//MARK: User Session
public struct FEUserSession: Codable {
    let accessToken: String?
    let refreshToken: String?
    
    static func saveLoginSession(session: Any) {
        if let encodedSession = try? JSONSerialization.data(withJSONObject: session) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedSession, forKey: "FEUserSession")
        }
    }

    static func getSession() -> FEUserSession? {
        let userDefaults = UserDefaults.standard
        guard let savedSessionData = userDefaults.object(forKey: "FEUserSession") as? Data,
              let savedSession = try? JSONDecoder().decode(FEUserSession.self, from: savedSessionData) else { return nil }
        return savedSession
    }
}

//MARK: Refresh Token
public struct FERefreshTokenRequest: Codable {
    let refreshToken: String?
    let cookie: String?
    
    init(token: String?, accessCookie: String?) {
        refreshToken = token
        cookie = "__frlc.session=\(accessCookie ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "Refresh-Token"
        case cookie = "Cookie"
    }
}


public struct FEAuthLoginRequest: Codable {
    let apiKey: String
    var userIdentifier: String = ""
}

