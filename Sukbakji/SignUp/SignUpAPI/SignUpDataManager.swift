//
//  SignUpDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Alamofire

class SignUpDataManager {
    let url = APIConstants.joinURL + "/signup"
    let emailUrl = APIConstants.joinURL + "/email"
    let headers:HTTPHeaders = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    func signUpDataManager(_ parameters: SignUpAPIInput, completion: @escaping (SignUpModel?) -> Void) {
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: SignUpModel.self) { response in
            switch response.result {
            case .success(let signUpModel):
                completion(signUpModel)
                print("성공. \(signUpModel)")
                
            case .failure(let error):
                    print("에러 : \(error.localizedDescription)")
            }
        }
    }
    
    func EmailDataManager(_ email: String, completion: @escaping (SignUpModel?) -> Void)  {
        AF.request(emailUrl,
                   method: .post,
                   parameters: email,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: SignUpModel.self) { response in
            switch response.result {
            case .success(let signUpModel) :
                completion(signUpModel)
                print("성공: \(signUpModel)")
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
}
