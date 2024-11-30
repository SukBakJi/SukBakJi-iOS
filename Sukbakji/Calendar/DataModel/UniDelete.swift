//
//  UniDelete.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniDelete : Encodable {
    let memberId: Int
    let univId: Int
    let season: String
    let method: String
}

struct UniDeleteResult : Codable {
    let memberId: Int
    let message: String
}
