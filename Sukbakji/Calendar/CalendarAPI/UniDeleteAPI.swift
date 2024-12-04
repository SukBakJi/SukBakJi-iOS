//
//  UniDeleteAPI.swift
//  Sukbakji
//
//  Created by jaegu park on 8/15/24.
//

import Foundation
import Alamofire

class APIUniDelete {
    static let instance = APIUniDelete()
    
    func SendingUniDelete(parameters: UniDelete, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let retrievedToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            return
        }
        
        let url = APIConstants.calendar.path + "/univ"
        let headers:HTTPHeaders = [
            "content-type": "application/json",
            "Authorization": "Bearer \(retrievedToken)"
        ]
        
        AF.request(url, method: .delete, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success:
                if let statusCode = response.response?.statusCode, 200..<300 ~= statusCode {
                    completion(.success(()))
                } else {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: response.response?.statusCode ?? 0)
                    print("Request failed with status code \(response.response?.statusCode ?? 0): \(errorDescription)")
                    completion(.failure(NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
