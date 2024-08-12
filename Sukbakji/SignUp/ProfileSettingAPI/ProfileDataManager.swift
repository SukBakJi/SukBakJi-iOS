//
//  ProfileDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation
import Alamofire

class ProfileDataManager {

    func ProfileDataManager(_ parameters: ProfileAPIInput, completion: @escaping (ProfileModel?) -> Void) {
        
        guard let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("토큰이 없습니다.")
            completion(nil)
            return
        }

        
        let url = APIConstants.userURL + "/profile"
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let profileModel):
                completion(profileModel)
                print("성공. \(profileModel)")
                
            case .failure(let error):
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
    
    
    func ProfileGetDataManager(completion: @escaping (ProfileModel?) -> Void) {
        
        guard let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("토큰이 없습니다.")
            completion(nil)
            return
        }

        
        let url = APIConstants.userURL + "/mypage"
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]
    
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ProfileModel.self) { response in
            switch response.result {
            case .success(let profileModel):
                completion(profileModel)
                print("성공. \(profileModel)")
                
            case .failure(let error):
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
}
