//
//  FCMTokenManager+.swift
//  Sukbakji
//
//  Created by jaegu park on 4/1/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private init() {}

    func saveFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "fcmToken")
    }

    func getFCMToken() -> String? {
        return UserDefaults.standard.string(forKey: "fcmToken")
    }
}
