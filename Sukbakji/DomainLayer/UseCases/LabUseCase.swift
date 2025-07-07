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
}
