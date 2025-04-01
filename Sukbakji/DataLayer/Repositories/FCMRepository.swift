//
//  FCMRepository.swift
//  Sukbakji
//
//  Created by jaegu park on 4/1/25.
//

import Foundation
import RxSwift

class FCMRepository {
    static let shared = FCMRepository()
    
    func postFCMToken(token: String, fcmToken: String) -> Single<APIResponse<String>> {
        let url = APIConstants.userFCMToken.path
        let params = ["fcmToken": fcmToken]
        return APIService.shared.postWithToken(of: APIResponse<String>.self, url: url, parameters: params, accessToken: token)
    }
}
