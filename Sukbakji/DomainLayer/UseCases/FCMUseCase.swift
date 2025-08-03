//
//  FCMUseCase.swift
//  Sukbakji
//
//  Created by jaegu park on 8/3/25.
//

import RxSwift

class FCMUseCase {
    private let fCMRepository: FCMRepository
    
    init(fCMRepository: FCMRepository = FCMRepository.shared) {
        self.fCMRepository = fCMRepository
    }
    
    func uploadFCMToken(fcmToken: String) -> Single<String> {
        guard let token = KeychainHelper.standard.read(service: "access-token", account: "user") else {
            return .error(NSError(domain: "TokenError", code: 401, userInfo: nil))
        }
        
        return fCMRepository.postFCMToken(token: token, fcmToken: fcmToken)
            .map { $0.message }
    }
}
