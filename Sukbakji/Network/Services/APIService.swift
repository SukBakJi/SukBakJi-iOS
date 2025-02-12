//
//  APIService.swift
//  Sukbakji
//
//  Created by jaegu park on 11/21/24.
//

import Foundation
import Alamofire
import RxSwift

struct APIService {
    
    static var shared = APIService()
    
    func get<T: Codable>(of type: T.Type, url: URLConvertible, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func getWithToken<T: Codable>(of type: T.Type, url: URLConvertible, accessToken: String) -> Single<T> {
        return Single<T>.create { single in
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]

            let request = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding(options: []),
                                     headers: headers)
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let value):
                        single(.success(value)) // 성공 시 Single을 방출
                    case .failure(let error):
                        single(.failure(error)) // 실패 시 에러 방출
                    }
                }
            
            return Disposables.create {
                request.cancel() // 구독이 해제되면 요청 취소
            }
        }
    }
    
    func getWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func getWithAccessTokenParameters<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any], AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Accept":"application/json", "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func post<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any], success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func postWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any]?, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func deleteWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any]?, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func patchWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any]?, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
    
    func putWithAccessToken<T: Codable>(of type: T.Type, url: URLConvertible, parameters: [String : Any]?, AccessToken: String, success: @escaping (T) -> (), failure: ((Error) -> ())? = nil) {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json",
                                    "Accept":"application/json",
                                    "Authorization" : "Bearer \(AccessToken)"]
        
        AF.request(url,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseDecodable(of: type) { response in
            
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                if let failure = failure {
                    failure(error)
                } else {
                    AlertController(message: error.localizedDescription).show()
                }
            }
        }
    }
}
