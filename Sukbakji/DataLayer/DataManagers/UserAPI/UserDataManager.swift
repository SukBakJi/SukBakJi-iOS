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
    let EduImageUrl = APIConstants.userEducationCertification.path
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    let multipartHeaders: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "multipart/form-data"
    ]
    
    // 프로필 설정
    func PostProfileDataManager(_ parameters: PostProfileRequestDTO, completion: @escaping (PostProfileResponseDTO?) -> Void) {
        NetworkAuthManager.shared.request(profileUrl,
                                          method: .post,
                                          parameters: parameters,
                                          encoder: JSONParameterEncoder.default,
                                          headers: headers)
        .validate(statusCode: 200..<300)
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
        .validate(statusCode: 200..<300)
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
    
    // 학력인증 이미지 첨부
    func PostEduImageDataManager(_ parameters: PostEduImageRequestDTO, completion: @escaping (PostEduImageResponseDTO?) -> Void) {
        NetworkAuthManager.shared.upload(multipartFormData: { multipartFormData in
            // Base64로 변환된 이미지 추가
            if let imageData = Data(base64Encoded: parameters.certificationPicture) {
                multipartFormData.append(imageData, withName: "certificationPicture", fileName: "image.png", mimeType: "image/png")
            }
            
            // 학력 인증 유형 추가
            if let typeData = parameters.educationCertificateType.data(using: .utf8) {
                multipartFormData.append(typeData, withName: "educationCertificateType")
            }
        }, to: EduImageUrl, method: .post, headers: multipartHeaders)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: PostEduImageResponseDTO.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
                print("학력 인증 이미지 업로드 성공: \(result)")
            case .failure(let error):
                print("학력 인증 이미지 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 애플 이메일 설정
    func PostAppleEmailDataManager(_ email: String, completion: @escaping (AppleEmailResponseDTO?) -> Void) {
        NetworkAuthManager.shared.request(profileUrl,
                                          method: .post,
                                          parameters: email,
                                          encoder: JSONParameterEncoder.default,
                                          headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: AppleEmailResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
                print("성공. \(data)")
                
            case .failure(let error):
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
}
