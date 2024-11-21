//
//  MentorPostAPI.swift
//  Sukbakji
//
//  Created by jaegu park on 8/16/24.
//

import Foundation
import Alamofire

class APIMentorPost {
    static let instance = APIMentorPost()
    
    func SendingPostMentor(parameters: MentorPostModel, handler: @escaping (_ result: MentorPostResult)->(Void)) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.mentor.path
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
                    
                    let jsonresult = try JSONDecoder().decode(MentorPostResult.self, from: data!)
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
