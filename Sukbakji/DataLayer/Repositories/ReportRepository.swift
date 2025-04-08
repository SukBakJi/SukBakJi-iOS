//
//  ReportRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 4/8/25.
//

import Foundation
import RxSwift

class ReportRepository {
    static let shared = ReportRepository()
    
    func fetchReportPost(token: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.reportsPost.path
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchReportComment(token: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.reportsComment.path
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
}
