//
//  LoginModel.swift
//  Sukbakji
//
//  Created by 오현민 on 8/9/24.
//

// 받아야하는거

// MARK: - LoginModel
struct LoginModel: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: LoginResult?
}

// MARK: - LoginResult
struct LoginResult: Decodable {
    let email: String?
    let accessToken : String?
    let refreshToken: String?
}
