//
//  ChatModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/31/25.
//

import Foundation

struct MentorListResponse : Codable {
    let memberId: Int
    var mentorList: [MentorList]
}

struct MentorList : Codable {
    let mentorId: Int
    let univName: String
    let profName: String
    let deptName: String
    let researchTopic: [String]
}

struct MentorPostResponse : Codable {
    let memberId: Int
    let message: String
}

struct MentoringPostResponse : Codable {
    let mentorId: Int
    let menteeId: Int
    let message: String
}
