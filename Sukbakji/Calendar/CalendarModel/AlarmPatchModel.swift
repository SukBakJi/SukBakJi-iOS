//
//  AlarmPatchModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/6/24.
//

import Foundation

struct AlarmPatchModel : Encodable {
    let alarmId: Int
}

struct AlarmPatchResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: AlarmPatchResponse
}

struct AlarmPatchResponse : Codable {
    let alarmId: Int
    let onoff: Int
}
