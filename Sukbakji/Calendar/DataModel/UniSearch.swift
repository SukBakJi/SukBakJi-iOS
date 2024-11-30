//
//  UniSearch.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UniResponse
}

struct UniResponse : Codable {
    var universityList: [UniListResponse]
}

struct UniListResponse : Codable {
    let id: Int
    let name: String
}
