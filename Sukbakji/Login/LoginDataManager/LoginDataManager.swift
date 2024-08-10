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
                
                if let accessToken = loginModel.result?.accessToken {
                    KeychainHelper.standard.save(Data(accessToken.utf8), service: "access-token", account: "user")
                }
                
                if let refreshToken = loginModel.result?.refreshToken {
                    KeychainHelper.standard.save(Data(refreshToken.utf8), service: "refresh-token", account: "user")
                }
        
                if let email = loginModel.result?.email {
                    KeychainHelper.standard.save(Data(email.utf8), service: "email", account: "user")
                }
                
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
}
