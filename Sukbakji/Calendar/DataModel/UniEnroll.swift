//
//  UniEnroll.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniPostModel : Encodable {
    let memberId: Int
    let univId: Int
    let season: String
    let method: String
}

struct UniPostResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UniPostResponse
}

struct UniPostResponse : Codable {
    let univId: Int
    let memberId: Int
}
