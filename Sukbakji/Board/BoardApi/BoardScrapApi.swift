//
//  BoardScrapApi.swift
//  Sukbakji
//
//  Created by KKM on 8/16/24.
//

//import Foundation
//import Alamofire
//
//func loadBoardScrapData(boardId: Int, completion: @escaping (Result<[BoardScrapResult], Error>) -> Void) {
//    // 인증 토큰을 가져옵니다.
//    guard let accessToken: String = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self), !accessToken.isEmpty else {
//        print("토큰이 없습니다.")
//        completion(.failure(NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
//        return
//    }
//    
//    // API URL을 정의합니다.
//    let url = APIConstants.baseURL + "/scrap/list"
//    
//    // 쿼리 파라미터로 사용할 매개변수를 설정합니다.
//    let parameters: [String: Any] = [
//        "boardId": boardId
//    ]
//    
//    // 헤더를 설정합니다.
//    let headers: HTTPHeaders = [
//        "Authorization": "Bearer \(accessToken)",
//        "Content-Type": "application/json"
//    ]
//    
//    // 요청을 수행합니다.
//    AF.request(url, method: .get, parameters: parameters, headers: headers)
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: BoardScrapModel.self) { response in
//            switch response.result {
//            case .success(let data):
//                if data.isSuccess {
//                    // 성공적으로 데이터를 불러오면, 결과를 반환합니다.
//                    completion(.success(data.result))
//                } else {
//                    // API 응답이 실패로 표시되었을 때, 오류를 반환합니다.
//                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: data.message])
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                // 네트워크 또는 디코딩 오류 발생 시, 해당 오류를 반환합니다.
//                completion(.failure(error))
//            }
//        }
//}
