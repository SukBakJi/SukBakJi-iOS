//
//  UpComing.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct UpComing : Codable {
    let memberId: Int
    var scheduleList: [UpComingList]
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case scheduleList
    }

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.scheduleList = try container.decodeIfPresent([UpComingList].self, forKey: .scheduleList) ?? []
    }
}

struct UpComingList : Codable {
    let univId: Int
    let content: String
    let dday: Int
}
