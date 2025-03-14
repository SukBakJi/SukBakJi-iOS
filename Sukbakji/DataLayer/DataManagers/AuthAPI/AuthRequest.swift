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
