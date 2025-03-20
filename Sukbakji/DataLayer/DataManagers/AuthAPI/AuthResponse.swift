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

//OAuth2 로그인
struct OAuthLoginResponseDTO: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: LoginResult?
}

struct LoginResult: Decodable {
    let provider, email, accessToken, refreshToken: String
}

// 이메일 중복 확인
struct CheckEmailResponseDTO: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: String?
}

// 이름과 전화번호로 이메일 찾기 공용
struct PostUserEmailResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: String?
}

// 비밀번호 재설정 (로그인 되어있지 않은 경우)
struct PostResetPasswordResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: String?
}

