//
//  UnivNameModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/13/24.
//

import Foundation

struct univNameResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: univNameResult
}

struct univNameResult : Codable {
    let univId: Int
    let univName: String
}
