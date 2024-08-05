//
//  AlarmPostModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/6/24.
//

import Foundation

struct AlarmPostModel : Encodable {
    let memberId: Int
    let univName: String
    let name: String
    let date: String
    let time: String
    let onoff: Int
}

struct AlarmPostResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: AlarmPostResponse
}

struct AlarmPostResponse : Codable {
    let alarmId: Int
    let alarmUnivName: String
    let alarmName: String
    let onoff: Int
    let memberId: Int
}
