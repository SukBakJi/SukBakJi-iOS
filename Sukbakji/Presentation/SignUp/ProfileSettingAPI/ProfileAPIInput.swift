//
//  ProfileAPIInput.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation

struct ProfileAPIInput : Encodable {
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
    
    var korean: String {
        switch self {
        case .bachelorsStudying: return "학사 재학 중"
        case .bachelorsGraduated: return "학사 졸업"
        case .mastersStudying: return "석사 재학 중"
        case .mastersGraduated: return "석사 졸업"
        case .doctoralStudying: return "박사 재학 중"
        case .doctoralGraduated: return "박사 졸업"
        case .integratedStudying: return "석박사 통합 재학"
        }
    }
    
    static func from(_ rawValue: String?) -> DegreeLevel? {
        guard let value = rawValue, !value.isEmpty else { return nil }
        return DegreeLevel(rawValue: value)
    }
}
