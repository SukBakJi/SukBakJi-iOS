//
//  ProfileDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation
import Alamofire

class UserDataManager {
    let profileUrl = APIConstants.userProfile.path
    let myPageurl = APIConstants.userMypage.path
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]

    // 프로필 설정
    func PostProfileDataManager(_ parameters: PostProfileRequestDTO, completion: @escaping (PostProfileResponseDTO?) -> Void) {
        NetworkAuthManager.shared.request(profileUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: PostProfileResponseDTO.self) { response in
            switch response.result {
            case .success(let profileModel):
                completion(profileModel)
                print("성공. \(profileModel)")
                
            case .failure(let error):
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
    
    // 마이페이지 정보 불러오기
    func GetMypageDataManager(completion: @escaping (PostProfileResponseDTO?) -> Void) {
        NetworkAuthManager.shared.request(myPageurl,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: PostProfileResponseDTO.self) { response in
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
