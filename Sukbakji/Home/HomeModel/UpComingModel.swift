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
}

struct UpcomingResponse : Codable {
    let univId: String
    let content: String
    let dday: Int
}
