//
//  AVDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Alamofire

class AVDataManager {

    func AVDataManager(_ parameters: AVAPIInput, completion: @escaping (AVModel?) -> Void) {
        guard let accessTokenData = KeychainHelper.standard.read(service: "access-token", account: "user"),
              let accessToken = String(data: accessTokenData, encoding: .utf8) else {
            print("Access token is missing or invalid.")
            completion(nil)
            return
        }
        
        let url = APIConstants.userURL + "/profile"
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // JSON 데이터를 직접 인코딩하여 출력해보세요.
        do {
            let jsonData = try JSONEncoder().encode(parameters)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Encoded JSON Data: \(jsonString)")
            }
        } catch {
            print("Failed to encode JSON: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        // 서버로 데이터 전송
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: AVModel.self) { response in
            switch response.result {
            case .success(let avModel):
                completion(avModel)
                print("성공. \(avModel)")
                
            case .failure(let error):
                // 서버로부터의 응답 데이터를 확인
                if let data = response.data, let json = String(data: data, encoding: .utf8) {
                    print("Server response data: \(json)")
                }
                print("에러 : \(error.localizedDescription)")
            }
        }
    }
}
