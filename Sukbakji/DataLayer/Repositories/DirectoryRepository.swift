//
//  DirectoryRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 6/13/25.
//

import Foundation
import RxSwift

class DirectoryRepository {
    static let shared = DirectoryRepository()
    
    func fetchFavoriteLabs(token: String) -> Single<APIResponse<[FavoriteLab]>> {
        let url = APIConstants.labsFavoriteLab.path
        return APIService.shared.getWithToken(of: APIResponse<[FavoriteLab]>.self, url: url, accessToken: token)
    }
    
    func fetchInterestTopics(token: String) -> Single<APIResponse<Topic>> {
        let url = APIConstants.labsInterestTopics.path
        return APIService.shared.getWithToken(of: APIResponse<Topic>.self, url: url, accessToken: token)
    }
    
    func fetchLabsReviews(token: String, offset: Int32, limit: Int32) -> Single<APIResponse<[LabReview]>> {
        let url = APIConstants.labsReviews.path
        let params = ["offset": offset,
                      "limit": limit]
        return APIService.shared.getWithTokenAndParams(of: APIResponse<[LabReview]>.self, url: url, parameters: params, accessToken: token)
    }
    
    func fetchLabsSearch(token: String, topicName: String, page: Int32, size: Int32) -> Single<APIResponse<Lab>> {
        let url = APIConstants.labsSearch.path
        let params = [
            "topicName": topicName,
            "page": page,
            "size": size] as [String : Any]
        return APIService.shared.postWithTokenAndParams(of: APIResponse<Lab>.self, url: url, parameters: params, accessToken: token)
    }
}
