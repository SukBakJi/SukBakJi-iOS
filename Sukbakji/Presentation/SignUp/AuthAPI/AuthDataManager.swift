//
//  authDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Alamofire

class AuthDataManager {
    let signupUrl = APIConstants.authSignUp.path
    let emailUrl = APIConstants.authEmail.path
    let loginUrl = APIConstants.authLogin.path
    let oauth2LoginUrl = APIConstants.authOauth2Login.path
    
    let headers:HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    // 일반 회원가입
    func signupDataManager(_ parameters: SignupRequestDTO, completion: @escaping (SignupResponseDTO?) -> Void) {
        AF.request(signupUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: SignupResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
                print("성공. \(data)")
                
            case .failure(let error):
                    print("에러 : \(error.localizedDescription)")
            }
        }
    }
    
    // 이메일 중복 확인
    func EmailDataManager(_ email: String, completion: @escaping (CheckEmailResponseDTO?) -> Void)  {
        AF.request(emailUrl,
                   method: .post,
                   parameters: email,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: CheckEmailResponseDTO.self) { response in
            switch response.result {
            case .success(let data) :
                completion(data)
                print("성공: \(data)")
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 일반 로그인
    func loginDataManager(_ parameters: LoginRequestDTO, completion: @escaping (LoginResponseDTO?) -> Void) {
        AF.request(loginUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: LoginResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
                
                if let accessToken = data.result?.accessToken,
                   let refreshToken = data.result?.refreshToken,
                   let email = data.result?.email {
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
    // Oauth2 로그인
    func oauth2LoginDataManager(_ parameters: Oauth2RequestDTO, completion: @escaping (OAuthLoginResponseDTO?) -> Void) {
        AF.request(oauth2LoginUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: OAuthLoginResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
                print("OAuth2 로그인 성공 ; \(data)")
                if let accessToken = data.result?.accessToken,
                   let refreshToken = data.result?.refreshToken,
                   let email = data.result?.email {
                    // 키체인에 저장
                    KeychainHelper.standard.save(Data(accessToken.utf8), service: "access-token", account: "user")
                    KeychainHelper.standard.save(Data(refreshToken.utf8), service: "refresh-token", account: "user")
                    KeychainHelper.standard.save(Data(email.utf8), service: "email", account: "user")
                    KeychainHelper.standard.delete(service: "password", account: "user")
                    
                }
                
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
//    // 카카오톡 로그인
//    func kakaoLoginDataManager(_ parameters: LoginRequestDTO, completion: @escaping (LoginResponseDTO?) -> Void) {
//        AF.request(kakaoUrl,
//                   method: .post,
//                   parameters: parameters,
//                   encoder: JSONParameterEncoder.default,
//                   headers: headers)
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: LoginResponseDTO.self) { response in
//            switch response.result {
//            case .success(let data):
//                print("카카오톡 회원가입/로그인 성공 : \(data)")
//                completion(data)
//                
//                if let accessToken = data.result?.accessToken,
//                   let refreshToken = data.result?.refreshToken,
//                   let email = data.result?.email {
//                    // 키체인에 저장
//                    KeychainHelper.standard.save(Data(accessToken.utf8), service: "access-token", account: "user")
//                    KeychainHelper.standard.save(Data(refreshToken.utf8), service: "refresh-token", account: "user")
//                    KeychainHelper.standard.save(Data(email.utf8), service: "email", account: "user")
//                    KeychainHelper.standard.delete(service: "password", account: "user")
//                    
//                }
//                
//            case .failure(let error):
//                print("요청 실패: \(error.localizedDescription)")
//            }
//        }
//    }
}
