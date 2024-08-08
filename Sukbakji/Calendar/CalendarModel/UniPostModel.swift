//
//  UniPostModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct UniPostModel : Encodable {
    let memberId: Int
    var setUnivList: [UniRequest]
}

struct UniRequest : Encodable {
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
