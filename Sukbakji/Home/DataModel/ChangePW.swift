//
//  ChangePW.swift
//  Sukbakji
//
//  Created by jaegu park on 11/30/24.
//

import Foundation

struct ChangePW : Encodable {
    let currentPassword: String
    let newPassword: String
    let confirmPassword: String
}
