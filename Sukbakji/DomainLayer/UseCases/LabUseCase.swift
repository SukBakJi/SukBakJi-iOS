//
//  LabUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 7/4/25.
//

import RxSwift

class LabUseCase {
    private let directoryRepository: DirectoryRepository
    
    init(directoryRepository: DirectoryRepository = DirectoryRepository.shared) {
        self.directoryRepository = directoryRepository
    }
    
    func fetchLabInfo(labId: Int) -> Single<LabInfo> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchLabInfo(token: token, labId: labId)
                    .map { $0.result }
    }
    
    func fetchLabDetail(labId: Int) -> Single<LabDetail> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchLabsReviewsId(token: token, labId: labId)
                    .map { $0.result }
    }
    
    func fetchLabReview(offset: Int32, limit: Int32) -> Single<[LabReview]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchLabsReviews(token: token, offset: offset, limit: limit)
            .map { $0.result }
    }
    
    func postLabReview(lab_id: Int, content: String, leadershipStyle: String, salaryLevel: String, autonomy: String) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .just(false)
        }
        
        let params: [String: Any] = [
            "content": content,
            "leadershipStyle": leadershipStyle,
            "salaryLevel": salaryLevel,
            "autonomy": autonomy
        ]
        
        return directoryRepository.PostLabsReviewsId(token: token, lab_id: lab_id, parameters: params)
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func fetchReviewSearch(professorName: String) -> Single<[LabReview]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchReviewsSearch(token: token, professorName: professorName)
            .map { $0.result }
    }
    
    func fetchLabSearch(topicName: String, page: Int32, size: Int32) -> Single<[LabSearch]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchLabsSearch(token: token, topicName: topicName, page: page, size: size)
            .map { $0.result.responseDTOList }
    }
    
    func fetchLabFavorite() -> Single<[FavoriteLab]> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.fetchFavoriteLabs(token: token)
            .map { $0.result }
    }
    
    func postLabFavorite(labId: Int) -> Single<Bool> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "토큰이 존재하지 않습니다."]))
        }
        
        return directoryRepository.favoriteLabToggle(token: token, labId: labId)
            .map { _ in true }
            .catchAndReturn(false)
    }
}
