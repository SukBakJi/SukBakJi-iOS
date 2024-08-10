//
//  LoginAPIInput.swift
//  Sukbakji
//
//  Created by 오현민 on 8/9/24.
//

// 보내야하는거
struct LoginAPIInput : Encodable {
    var email : String?
    var password : String?
}
