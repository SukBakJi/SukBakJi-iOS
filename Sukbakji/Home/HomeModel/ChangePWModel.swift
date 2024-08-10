//
//  ChangePWModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct ChangePWModel : Encodable {
    let currentPassword: String
    let newPassword: String
    let confirmPassword: String
}

struct ChangePWResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: String
}
