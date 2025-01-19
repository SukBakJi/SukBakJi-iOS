//
//  AlarmEnroll.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct AlarmPostResult : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let onoff: Int
    let memberId: Int
}
