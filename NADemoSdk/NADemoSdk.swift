//
//  NADemoSdk.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 05/10/23.
//

import Foundation
public final class NADemoSdk {
    
    //MARK: Initialisation
     private var interactor: FLServiceInteractorProtocol
    
     init(interactor: FLServiceInteractorProtocol){
        self.interactor = interactor
    }
    private var apiKey: String = ""
   public static let shared = NADemoSdk(interactor: FEServiceInteractor())

    
    public func configureSDK(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func authLogin(userId: String, onSuccess:@escaping (FLServiceSuccessBlock), onFailure:@escaping FLServiceFailureBlock) {
        interactor.request(forAPI: .authLogin(apiKey, userId)) { response, error in
           if let response = response {
               FEUserSession.saveLoginSession(session: response)
               onSuccess()
           } else {
               onFailure(error)
           }
        }
    }
}
