//
//  AlarmListModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
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
}

struct AlarmList : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let alarmDate: String
    let alarmTime: String
    let onoff: Int
}
