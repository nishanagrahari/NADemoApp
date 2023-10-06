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
    
}
