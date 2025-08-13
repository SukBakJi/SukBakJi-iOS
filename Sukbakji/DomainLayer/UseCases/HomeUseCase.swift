//
//  HomeUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 4/14/25.
//

import RxSwift

class HomeUseCase {
    private let homeRepository: HomeRepository
    
    init(homeRepository: HomeRepository = HomeRepository.shared) {
        self.homeRepository = homeRepository
    }
    
    func fetchFavoriteBoard() -> Single<[FavoriteBoard]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return homeRepository.fetchFavoriteBoard(token: token)
                    .map { $0.result }
    }
    
    func fetchHotPost() -> Single<[HotPost]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return homeRepository.fetchHotPost(token: token)
                    .map { $0.result }
    }
    
    func fetchMyProfile() -> Single<MyProfile> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return homeRepository.fetchMyProfile(token: token)
                    .map { $0.result }
    }
    
    func editProfile(degree: String, topics: [String]) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "degreeLevel": degree,
            "researchTopics": topics
        ]
        
        return homeRepository.fetchEditProfile(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func logOut() -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        return homeRepository.fetchLogOut(token: token)
            .do(onSuccess: { _ in
                self.clearUserCredentials()
            })
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func changePassword(newPassword: String, confirmPassword: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
        ]
        
        return homeRepository.fetchChangePW(token: token, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    private func clearUserCredentials() {
        KeychainHelper.standard.delete(service: "access-token", account: "user")
        KeychainHelper.standard.delete(service: "refresh-token", account: "user")
        KeychainHelper.standard.delete(service: "email", account: "user")
        KeychainHelper.standard.delete(service: "password", account: "user")
    }
}

