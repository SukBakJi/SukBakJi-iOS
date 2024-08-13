//
//  SelectDateModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/13/24.
//

import Foundation

struct DateResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: DateResponse
}

struct DateResponse : Codable {
    let memberId: Int
    var scheduleList: [DateListResponse]
}

struct DateListResponse : Codable {
    let univId: Int
    let content: String
}
