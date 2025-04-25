//
//  SmsDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import Alamofire

class SmsDataManager {
    let smsVerifylUrl = APIConstants.smsPhoneVerify.path
    let smsCodeUrl = APIConstants.smsPhone.path
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    // 인증번호 검증
    func smsVerifyDataManager(_ parameters: VerifyCodeRequestDTO, completion: @escaping (SmsResponseDTO?) -> Void) {
        AF.request(
            smsVerifylUrl,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: SmsResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
                print("성공. \(data)")
                
            case .failure(let error):
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
    
    // 인증번호 요청
    func smsCodeDataManager(_ parameters: SmsCodeRequestDTO, completion: @escaping (SmsResponseDTO?) -> Void) {
        print(parameters)
        AF.request(
            smsCodeUrl,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: SmsResponseDTO.self) { response in
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
