//
//  SignUpDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Alamofire

class SignUpDataManager {
    let url = APIConstants.joinURL + "/signup"
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
}
