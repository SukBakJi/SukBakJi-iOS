//
//  CalendarModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/24/25.
//

import Foundation
import RxDataSources

struct UpComing : Codable {
    let memberId: Int
    var scheduleList: [UpComingResult]
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case scheduleList
    }

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.scheduleList = try container.decodeIfPresent([UpComingResult].self, forKey: .scheduleList) ?? []
    }
}

struct UpComingResult : Codable {
    let univId: Int
    let content: String
    let dday: Int
}

struct UniSearch : Codable {
    var universityList: [UniSearchList]
}

struct UniSearchList : Codable {
    let id: Int
    let name: String
}

struct UniMethod : Codable {
    let univId: Int
    var methodList: [UniMethodList]
}

struct UniMethodList : Codable {
    let method: String
}

struct UniPostResult : Codable {
    let univId: Int
    let memberId: Int
}

struct UnivList: Codable {
    let memberId: Int
    var univList: [UnivListResult]

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.univList = try container.decodeIfPresent([UnivListResult].self, forKey: .univList) ?? []
    }
}

struct UnivListResult: Codable {
    let univId: Int
    let season: String
    let method: String
    let showing: Int
}

struct UnivListSection {
    var items: [UnivListResult]
}

extension UnivListSection: SectionModelType {
    typealias Item = UnivListResult
    
    init(original: UnivListSection, items: [Item]) {
        self = original
        self.items = items
    }
}

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

struct AlarmPostResult : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let onoff: Int
    let memberId: Int
}

struct AlarmList : Codable {
    let memberId: Int
    var alarmList: [AlarmListResult]
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case alarmList
    }

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.alarmList = try container.decodeIfPresent([AlarmListResult].self, forKey: .alarmList) ?? []
    }
}

struct AlarmListResult : Codable {
    let alarmId: Int
    var alarmUnivName: String
    var alarmName: String
    var alarmDate: String
    var alarmTime: String
    var onoff: Int
}

struct AlarmListSection {
    var items: [AlarmListResult]
}

extension AlarmListSection: SectionModelType {
    typealias Item = AlarmListResult
    
    init(original: AlarmListSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct AlarmPatchResult : Codable {
    let alarmId: Int
    let onoff: Int
}

struct DateSelect : Codable {
    let memberId: Int
    var scheduleList: [DateSelectList]
}

struct DateSelectList : Codable {
    let univId: Int
    let content: String
}

struct DateSelectSection {
    var items: [DateSelectList]
}

extension DateSelectSection: SectionModelType {
    typealias Item = DateSelectList
    
    init(original: DateSelectSection, items: [Item]) {
        self = original
        self.items = items
    }
}
