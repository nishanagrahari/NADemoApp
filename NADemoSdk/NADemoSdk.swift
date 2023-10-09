//
//  NADemoSdk.swift
//  NADemoSdk
//
//  Created by Nageshwar Agrahari on 05/10/23.
//

import Foundation
public final class NADemoSdk {

    //MARK: Initialisation
    static let shared = NADemoSdk()
    
    let name = "NADemoSdk"
    
    public func add(a: Int, b: Int) -> Int {
        return a + b
    }
    
    public func sub(a: Int, b: Int) -> Int {
        return a - b
    }
    
    func getData() {
        
    }
    
    
    //MARK: Login
    func requestOTP(onSuccess:@escaping FLServiceSuccessBlock, onFailure:@escaping FLServiceFailureBlock) {
        FEServiceInteractor.shared.request(forAPI: .login("")) { dataResponse, error in
            
            if let response = dataResponse {
                print(response)
            }
//            guard error?.failureReason !=  "Response could not be decoded because of error:\nThe data couldn’t be read because it isn’t in the correct format." else {
//                onFailure("FLTranslations.shared.somethingWrongTry")
//                return
//            }
//            guard let loginResponse = response,
//                  let attempts = loginResponse.attempts, attempts > 0
            else {
                onFailure(error);
                return
            }
            onSuccess()
        }
    }
    
}
