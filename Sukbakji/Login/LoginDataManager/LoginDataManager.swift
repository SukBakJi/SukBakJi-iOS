//
//  LoginDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/9/24.
//

import Alamofire

class LoginDataManager {
    let url = "http://54.180.165.121:8080/api/auth/login"
    
    func loginDataManager(_ parameters: LoginAPIInput,
                          completion: @escaping (LoginModel?) -> Void) {
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Accept": "*/*", "Content-Type": "application/json"])
        .validate(statusCode: 200..<500)
        .responseDecodable(of: LoginModel.self) { response in
            switch response.result {
            case .success(let loginModel):
                completion(loginModel)
                
                if let accessToken = loginModel.result?.accessToken,
                   let refreshToken = loginModel.result?.refreshToken,
                   let email = loginModel.result?.email {
                    // 키체인에 저장
                    KeychainHelper.standard.save(Data(accessToken.utf8), service: "access-token", account: "user")
                    KeychainHelper.standard.save(Data(refreshToken.utf8), service: "refresh-token", account: "user")
                    KeychainHelper.standard.save(Data(email.utf8), service: "email", account: "user")
                    
                    // 비밀번호 저장 추가
                    if let password = parameters.password {
                        KeychainHelper.standard.save(Data(password.utf8), service: "password", account: "user")
                    }
                }
                
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
}