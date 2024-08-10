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
    let member_id: Int
    let university_id: Int
    let university_name: String
    var schedule: [UpcomingResponse]
}
struct UpcomingResponse : Codable {
    let content: String
    let date: String
}
