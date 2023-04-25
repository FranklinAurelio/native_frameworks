//
//  LocalAuthentication.swift
//  Alura Ponto
//
//  Created by Franklin Carvalho on 25/04/23.
//

import Foundation
import LocalAuthentication

class LocalAuthentication {
    
    private let authenticatorContext = LAContext()
    private let authenticationString: String  = "Autentique o dispositivo para prosseguir"
    private var error: NSError?
    
    func authUser(completion: @escaping(_ auth: Bool) -> Void) {
        if authenticatorContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            authenticatorContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authenticationString) { sucesso, error in
                
                completion(sucesso)
                
            }
        }
    }
}
