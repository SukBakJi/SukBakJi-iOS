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
    
    func fetchMyProfile(token: String, url: String) -> Single<APIResponse<MyProfile>> {
        return APIService.shared.getWithToken(of: APIResponse<MyProfile>.self, url: url, accessToken: token)
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
    
    func fetchUpComing(token: String, url: String) -> Single<APIResponse<[UpComing]>> {
        return APIService.shared.getWithToken(of: APIResponse<[UpComing]>.self, url: url, accessToken: token)
    }
    
    func fetchLogOut(token: String, url: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchEditProfile(token: String, url: String, parameters: [String: Any]?) -> Single<APIResponse<EditProfile>> {
        return APIService.shared.putWithToken(of: APIResponse<EditProfile>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchChangePW(token: String, url: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
}
