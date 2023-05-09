//
//  ReciboService.swift
//  Native Framewoks
//
//  Created by Franklin Carvalho on 05/05/23.
//

import Foundation
import Alamofire

class ReciboSrevice{
    
    private let baseUrl = "http://localhost:8080/"
    
    
    //MARK: - POST
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
    
    //MARK: - GET
    func get( completion: @escaping(_ recibos: [Recibo]?, _ error: Error?) -> Void){
        let path = "recibos"
        AF.request(baseUrl + path, method: .get, headers: ["Accept": "application/json"]).responseJSON { response in
            switch response.result{
            case .success(let json):
                
                var recibos: [Recibo] = []
                
                if let listResponse = json as? [[String : Any]]{
                    for reciboDict in listResponse {
                        if let newRecibo = Recibo.serialize(reciboDict){
                            recibos.append(newRecibo)
                        }
                    }
                    
                    completion(recibos, nil)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
    
    //MARK: - DELETE
    func delete(id: String, completion: @escaping() -> Void){
        let path = "recibos/"
        AF.request(baseUrl + path + id, method: .delete, headers: ["Accept": "application/json"]).responseData { _ in
            completion() 
        }
    }
    
    
}
