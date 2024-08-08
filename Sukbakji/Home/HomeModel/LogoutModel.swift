//
//  LogoutModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation

struct LogoutModel : Encodable {
    let accessToken: String
}

struct LogoutResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String
}
