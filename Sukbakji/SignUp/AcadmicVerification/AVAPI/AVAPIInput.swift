//
//  AVInput.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Foundation

struct AVAPIInput : Encodable {
    var name : String?
    var degreeLevel : DegreeLevel
    var researchTopics: [String] = []
}

enum DegreeLevel: String, Encodable {
    case bachelorsStudying = "BACHELORS_STUDYING"
    case bachelorsGraduated = "BACHELORS_GRADUATED"
    case mastersStudying = "MASTERS_STUDYING"
    case mastersGraduated = "MASTERS_GRADUATED"
    case doctoralStudying = "DOCTORAL_STUDYING"
    case doctoralGraduated = "DOCTORAL_GRADUATED"
    case integratedStudying = "INTEGRATED_STUDYING"
}
