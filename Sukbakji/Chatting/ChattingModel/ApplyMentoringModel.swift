//
//  ApplyMentoringModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/16/24.
//

import Foundation

struct MentoringPostModel : Encodable {
    let memberId: Int
    let mentorId: Int
    let subject: String
    let question: String
}

struct MentoringPostResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: MentoringPostResponse
}

struct MentoringPostResponse : Codable {
    let mentorId: Int
    let menteeId: Int
    let message: String
}
