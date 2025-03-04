//
//  SmsDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import Alamofire

class SmsDataManager {
    let findEmailUrl = APIConstants.smsFindEmail.path
    let smsCodeUrl = APIConstants.smsCode.path
    
    let headers: HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    // 아이디(이메일) 찾기
    func findEmailDataManager(_ parameters: FindEmailRequestDTO, completion: @escaping (SmsResponseDTO?) -> Void) {
        NetworkAuthManager.shared.request(
            findEmailUrl,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers)
        .validate(statusCode: 200..<500)
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
        NetworkAuthManager.shared.request(
            findEmailUrl,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: headers)
        .validate(statusCode: 200..<500)
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
