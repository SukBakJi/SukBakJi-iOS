//
//  ApplyMentorModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/16/24.
//

import Foundation

struct MentorPostModel : Encodable {
    let memberId: Int
    let univName: String
    let dept: String
    let profName: String
}

struct MentorPostResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: MentorPostResponse
}

struct MentorPostResponse : Codable {
    let memberId: Int
    let message: String
}
