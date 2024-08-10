//
//  MemberIDModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/10/24.
//

import Foundation

struct memberIdResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: memberIdResult
}

struct memberIdResult : Codable {
    let memberId: Int
}
