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
    
    func fetchMyProfile(token: String) -> Single<APIResponse<MyProfile>> {
        let url = APIConstants.userMypage.path
        return APIService.shared.getWithToken(of: APIResponse<MyProfile>.self, url: url, accessToken: token)
    }
    
    func fetchFavoriteBoard(token: String) -> Single<APIResponse<[FavoriteBoard]>> {
        let url = APIConstants.communityFavoriteBoard.path
        return APIService.shared.getWithToken(of: APIResponse<[FavoriteBoard]>.self, url: url, accessToken: token)
    }
    
    func fetchHotPost(token: String) -> Single<APIResponse<[HotPost]>> {
        let url = APIConstants.communityHotPost.path
        return APIService.shared.getWithToken(of: APIResponse<[HotPost]>.self, url: url, accessToken: token)
    }
    
    func fetchFavoriteLab(token: String) -> Single<APIResponse<[FavoriteLab]>> {
        let url = APIConstants.labsFavoriteLab.path
        return APIService.shared.getWithToken(of: APIResponse<[FavoriteLab]>.self, url: url, accessToken: token)
    }
    
    func fetchLogOut(token: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.authLogout.path
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchEditProfile(token: String, parameters: [String: Any]?) -> Single<APIResponse<EditProfile>> {
        let url = APIConstants.userProfile.path
        return APIService.shared.putWithToken(of: APIResponse<EditProfile>.self, url: url, parameters: parameters, accessToken: token)
    }
    
    func fetchChangePW(token: String, parameters: [String: Any]?) -> Single<APIResponse<String>> {
        let url = APIConstants.userPassword.path
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: parameters, accessToken: token)
    }
}
