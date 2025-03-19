//
//  AuthRequest.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Foundation

struct SignupRequestDTO : Encodable {
    var provider : String
    var email : String
    var password : String
    var phoneNumber: String
}

struct LoginRequestDTO : Encodable {
    var email : String?
    var password : String?
}

struct Oauth2RequestDTO: Encodable {
    var provider: String
    var accessToken: String
}

// 이름과 전화번호로 이메일 찾기
struct PostUserEmailRequestDTO: Codable {
    let name: String
    let phoneNumber: String
}

// 이메일 인증번호 인증
struct PostUserEmailCodeRequestDTO: Codable {
    let email: String
    let code: String
}
