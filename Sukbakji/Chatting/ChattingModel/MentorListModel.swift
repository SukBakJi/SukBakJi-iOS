//
//  MentorListModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/14/24.
//

import Foundation

struct MentorListResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: MentorListResponse
}

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
