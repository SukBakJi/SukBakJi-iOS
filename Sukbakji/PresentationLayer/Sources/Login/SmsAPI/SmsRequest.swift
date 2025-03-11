//
//  SmsRequest.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import Foundation

struct SmsCodeRequestDTO: Codable {
    var phoneNumber: String
}

struct VerifyCodeRequestDTO: Codable {
    var phoneNumber: String
    var verificationCode: String
}
