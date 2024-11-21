//
//  EditProfilePut.swift
//  Sukbakji
//
//  Created by jaegu park on 8/15/24.
//

import Foundation
import Alamofire

class APIEditProfile {
    static let instance = APIEditProfile()
    
    func SendingEditProfile(parameters: EditProfileModel, handler: @escaping (_ result: EditProfileResult)->(Void)) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("Failed to retrieve password.")
            return
        }
        
        let url = APIConstants.user.path + "/profile"
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Authorization": "Bearer \(retrievedToken)"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { responce in
            switch responce.result {
            case .success(let data):
                print(String(decoding: data!, as: UTF8.self))
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
                    print(json)
                    
                    let jsonresult = try JSONDecoder().decode(EditProfileResult.self, from: data!)
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
