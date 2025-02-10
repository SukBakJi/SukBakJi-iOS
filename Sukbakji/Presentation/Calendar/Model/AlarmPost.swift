//
//  AlarmPost.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct AlarmPost : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let onoff: Int
    let memberId: Int
}
