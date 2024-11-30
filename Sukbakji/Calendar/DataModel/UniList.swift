//
//  UniList.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UnivListResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UnivListResponse
}

struct UnivListResponse: Codable {
    let memberId: Int
    var univList: [UnivList]

    enum CodingKeys: String, CodingKey {
        case memberId
        case univList
    }

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
