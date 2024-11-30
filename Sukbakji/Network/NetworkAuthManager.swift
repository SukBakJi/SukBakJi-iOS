//
//  NetworkManager.swift
//  Sukbakji
//
//  Created by 오현민 on 8/19/24.
//

import Alamofire

class NetworkAuthManager {
    static let shared: Session = {
        let interceptor = AuthInterceptor()
        return Session(interceptor: interceptor)
    }()
}
