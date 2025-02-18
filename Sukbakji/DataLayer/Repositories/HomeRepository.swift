//
//  HomeRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 2/18/25.
//

import Foundation
import RxSwift

class HomeRepository {
    static let shared = HomeRepository()
    
    func fetchMemberId(token: String, url: String) -> Single<APIResponse<MemberId>> {
        return APIService.shared.getWithToken(of: APIResponse<MemberId>.self, url: url, accessToken: token)
    }
    
    func fetchFavoriteBoard(token: String, url: String) -> Single<APIResponse<[FavoriteBoard]>> {
        return APIService.shared.getWithToken(of: APIResponse<[FavoriteBoard]>.self, url: url, accessToken: token)
    }
    
    func fetchHotPost(token: String, url: String) -> Single<APIResponse<[HotPost]>> {
        return APIService.shared.getWithToken(of: APIResponse<[HotPost]>.self, url: url, accessToken: token)
    }
    
    func fetchFavoriteLab(token: String, url: String) -> Single<APIResponse<[FavoriteLab]>> {
        return APIService.shared.getWithToken(of: APIResponse<[FavoriteLab]>.self, url: url, accessToken: token)
    }
    
    func fetchMyProfile(token: String, url: String) -> Single<APIResponse<MyProfile>> {
        return APIService.shared.getWithToken(of: APIResponse<MyProfile>.self, url: url, accessToken: token)
    }
}
