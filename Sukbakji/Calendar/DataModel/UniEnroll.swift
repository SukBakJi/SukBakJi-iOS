//
//  UniEnroll.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniPost : Encodable {
    let memberId: Int
    let univId: Int
    let season: String
    let method: String
}

struct UniPostResult : Codable {
    let univId: Int
    let memberId: Int
}
