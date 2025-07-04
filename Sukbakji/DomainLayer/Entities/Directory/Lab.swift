//
//  Lab.swift
//  Sukbakji
//
//  Created by jaegu park on 6/21/25.
//

import Foundation

struct Lab : Codable {
    var responseDTOList: [LabSearch]
    var totalNumber: Int
}

struct LabSearch : Codable {
    var labId: Int
    var labName: String
    var universityName: String
    var departmentName: String
    var professorName: String
    var researchTopics: [String]
}

struct LabInfo : Codable {
    var professorName: String
    var universityName: String
    var departmentName: String
    var labLink: String
    var researchTopics: [String]
    var professorEmail: String
}
