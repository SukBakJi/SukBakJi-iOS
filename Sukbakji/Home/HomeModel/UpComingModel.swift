//
//  UpComingModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct UpComingResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UpComingResult
}

struct UpComingResult : Codable {
    let memberId: Int
    var scheduleList: [UpcomingResponse]
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case scheduleList
    }

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.scheduleList = try container.decodeIfPresent([UpcomingResponse].self, forKey: .scheduleList) ?? []
    }
}

struct UpcomingResponse : Codable {
    let univId: Int
    let content: String
    let dday: Int
}
