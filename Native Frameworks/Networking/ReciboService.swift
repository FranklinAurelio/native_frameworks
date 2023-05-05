//
//  ReciboService.swift
//  Native Framewoks
//
//  Created by Franklin Carvalho on 05/05/23.
//

import Foundation

class ReciboSrevice{
    
    private let baseUrl = "http://localhost:8080/"
    
    func post(_ recibo: Recibo, completion: @escaping(_ isSave: Bool) -> Void){
        let path = "recibos"
        
        let params: [String: Any] = [
            "data": FormatadorDeData().getData(recibo.data),
            "status": recibo.status,
            "localizacao": [
                "latitude": recibo.lat,
                "longitude": recibo.lng
            ]
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        
        guard let url = URL(string: baseUrl + path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, resposta, error in
        
            if error == nil {
                completion(true)
                return
            }
            completion(false)
            
        }.resume()
    }
    
}
