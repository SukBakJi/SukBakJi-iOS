//
//  SignUpDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Alamofire

class SignUpDataManager {
    let url = "http://54.180.165.121:8080/api/auth/signup"
    
    func signUpDataManager(_ parameters: SignUpAPIInput,
                           completion: @escaping (SignUpModel?) -> Void) {
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Accept": "*/*", "Content-Type": "application/json"])
        .validate(statusCode: 200..<500)
        .responseDecodable(of: SignUpModel.self) { response in
            switch response.result {
            case .success(let signUpModel):
                completion(signUpModel)
                print("성공. \(signUpModel)")
                
            case .failure(let error):
                    // 디버깅을 위해 원시 데이터를 출력
                    if let data = response.data, let json = String(data: data, encoding: .utf8) {
                        print("Server response data: \(json)")
                    }
                    print("에러 : \(error.localizedDescription)")
            }
        }
    }
}
