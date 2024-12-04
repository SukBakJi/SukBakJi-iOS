//
//  LogoutPost.swift
//  Sukbakji
//
//  Created by jaegu park on 8/15/24.
//

import Foundation
import Alamofire

class APILogoutPost {
    static let instance = APILogoutPost()
    
    func SendingLogout(parameters: Logout, handler: @escaping (_ result: Logout)->(Void)) {
//        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
//            print("Failed to retrieve password.")
//            return
//        }
//        
//        let url = APIConstants.auth.path + "/logout"
//        let headers:HTTPHeaders = [
//            "content-type": "application/json",
//            "Authorization": "Bearer \(retrievedToken)"
//        ]
//        
//        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { responce in
//            switch responce.result {
//            case .success(let data):
//                print(String(decoding: data!, as: UTF8.self))
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
//                    print(json)
//                    
//                    let jsonresult = try JSONDecoder().decode(LogoutResult.self, from: data!)
//                    handler(jsonresult)
//                    print(jsonresult)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
