//
//  MentorList.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct MentorList : Codable {
    let memberId: Int
    var mentorList: [MentorListResult]
}

struct MentorListResult : Codable {
    let mentorId: Int
    let univName: String
    let profName: String
    let deptName: String
    let researchTopic: [String]
}
