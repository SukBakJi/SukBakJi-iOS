//
//  UnivDelete.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct UnivDelete : Encodable {
    let memberId: Int
    let univId: Int
    let season: String
    let method: String
}

struct UnivDeleteResult : Codable {
    let memberId: Int
    let message: String
}
