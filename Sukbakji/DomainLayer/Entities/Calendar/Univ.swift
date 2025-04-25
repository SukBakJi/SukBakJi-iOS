//
//  Univ.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct Univ: Codable {
    let memberId: Int
    var univList: [UnivList]

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.univList = try container.decodeIfPresent([UnivList].self, forKey: .univList) ?? []
    }
}

struct UnivList: Codable {
    let univId: Int
    let season: String
    let method: String
    let showing: Int
}

struct UnivPost: Codable {
    let memberId: Int
    let message: String
}
