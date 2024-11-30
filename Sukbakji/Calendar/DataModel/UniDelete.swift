//
//  UniDelete.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniDeleteModel : Encodable {
    let memberId: Int
    let univId: Int
    let season: String
    let method: String
}

struct UniDeleteResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UniDeleteResponse
}

struct UniDeleteResponse : Codable {
    let memberId: Int
    let message: String
}
