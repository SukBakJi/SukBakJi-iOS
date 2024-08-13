//
//  ResearchTopicDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/11/24.
//

import Alamofire

class ResearchTopicDataManager {
    func ResearchTopicDataManager(_ topicName: String, completion: @escaping (ResearchTopicModel?) -> Void) {
        guard let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) else {
            print("토큰이 없습니다.")
            completion(nil)
            return
        }

        
        let url = APIConstants.reseachtopicURL + "/search" + "?topicName=\(topicName)"
        
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: topicName,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: ResearchTopicModel.self) { response in
            switch response.result {
            case .success(let researchTopicModel) :
                completion(researchTopicModel)
                print("성공: \(researchTopicModel)")
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
}
