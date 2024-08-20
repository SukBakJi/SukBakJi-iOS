//
//  ResearchTopicDataManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/11/24.
//

import Alamofire

class ResearchTopicDataManager {
    func ResearchTopicDataManager(_ topicName: String, completion: @escaping (ResearchTopicModel?) -> Void) {
        
        let url = APIConstants.reseachtopicURL + "/search" + "?topicName=\(topicName)"
        
        let headers: HTTPHeaders = [
            "Accept": "*/*"
        ]
        
        NetworkManager.shared.request(url,
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
