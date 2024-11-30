//
//  AlarmList.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct AlarmResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: AlarmResponse
}

struct AlarmResponse : Codable {
    let memberId: Int
    var alarmList: [AlarmList]
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case alarmList
    }

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.alarmList = try container.decodeIfPresent([AlarmList].self, forKey: .alarmList) ?? []
    }
}

struct AlarmList : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let alarmDate: String
    let alarmTime: String
    let onoff: Int
}
