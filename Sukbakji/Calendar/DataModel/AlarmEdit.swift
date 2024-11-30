//
//  AlarmEdit.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct AlarmPatch : Encodable {
    let alarmId: Int
}

struct AlarmPatchResult : Codable {
    let alarmId: Int
    let onoff: Int
}
