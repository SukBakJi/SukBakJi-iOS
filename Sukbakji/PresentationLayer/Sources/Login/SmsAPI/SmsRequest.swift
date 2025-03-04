//
//  SmsRequest.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import Foundation

struct FindEmailRequestDTO: Codable {
    var phoneNumber: String
    var verificationCode: String
}

struct SmsCodeRequestDTO: Codable {
    var phoneNumber: String
}
