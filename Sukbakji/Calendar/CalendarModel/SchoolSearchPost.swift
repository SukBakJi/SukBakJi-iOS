//
//  SchoolSearchPost.swift
//  Sukbakji
//
//  Created by jaegu park on 7/31/24.
//

import Foundation
import Alamofire

class APISchoolPost {
    static let instance = APISchoolPost()
    
    func SendingPostReborn(search: String, parameters: SchoolModel, handler: @escaping (_ result: SchoolResultModel)->(Void)) {
        let url = "http://jrady721.cafe24.com/api/school/\(search)"
        let headers:HTTPHeaders = [
            "content-type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).response { responce in
            switch responce.result {
            case .success(let data):
                print(String(decoding: data!, as: UTF8.self))
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
                    print(json)
                    
                    let jsonresult = try JSONDecoder().decode(SchoolResultModel.self, from: data!)
                    handler(jsonresult)
                    print(jsonresult)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
