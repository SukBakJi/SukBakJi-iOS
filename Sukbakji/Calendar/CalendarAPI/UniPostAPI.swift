//
//  UniPostAPI.swift
//  Sukbakji
//
//  Created by jaegu park on 8/13/24.
//

import Foundation
import Alamofire

class APIUniPost {
    static let instance = APIUniPost()
    
    func SendingPostUni(parameters: UniPost, handler: @escaping (_ result: UniPostResult)->(Void)) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.calendar.path + "/univ"
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Authorization": "Bearer \(retrievedToken)"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { responce in
            switch responce.result {
            case .success(let data):
                print(String(decoding: data!, as: UTF8.self))
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
                    print(json)
                    
                    let jsonresult = try JSONDecoder().decode(UniPostResult.self, from: data!)
                    handler(jsonresult)
                    print(jsonresult)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

