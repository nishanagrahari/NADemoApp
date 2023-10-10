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
    
   public static let shared = NADemoSdk(interactor: FEServiceInteractor())

    
    
    //MARK: Login
    public func requestOTP(onSuccess:@escaping FLServiceSuccessBlock, onFailure:@escaping FLServiceFailureBlock) {
        interactor.request(forAPI: .login("")) { dataResponse, error in
            
            if let response = dataResponse {
                print(response)
            }
            else {
                onFailure(error);
                return
            }
            onSuccess()
        }
    }
    
    public func configureSDK(apiKey: String) {
            interactor.request(forAPI: .login("")) { dataResponse, error in
                if let response = dataResponse {
                    print(response)
                }
                else {
                    return
                }
            }
    }
}
