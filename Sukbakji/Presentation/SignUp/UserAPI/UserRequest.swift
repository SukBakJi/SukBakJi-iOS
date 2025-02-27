//
//  ProfileAPIInput.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation

struct PostProfileRequestDTO : Encodable {
    var name : String?
    var degreeLevel : DegreeLevel
    var researchTopics: [String] = []
}

enum DegreeLevel: String, Codable {
    case bachelorsStudying = "BACHELORS_STUDYING"
    case bachelorsGraduated = "BACHELORS_GRADUATED"
    case mastersStudying = "MASTERS_STUDYING"
    case mastersGraduated = "MASTERS_GRADUATED"
    case doctoralStudying = "DOCTORAL_STUDYING"
    case doctoralGraduated = "DOCTORAL_GRADUATED"
    case integratedStudying = "INTEGRATED_STUDYING"
}
