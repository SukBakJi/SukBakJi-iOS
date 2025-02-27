//
//  AuthResponse.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Foundation

// 회원가입
struct SignupResponseDTO: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: String?
}

// 일반로그인
struct LoginResponseDTO: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: LoginResult?
}

struct LoginResult: Decodable {
    let email: String?
    let accessToken : String?
    let refreshToken: String?
}

// 이메일 중복 확인
struct CheckEmailResponseDTO: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: String?
}
