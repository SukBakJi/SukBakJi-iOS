//
//  FavoriteLab.swift
//  Sukbakji
//
//  Created by jaegu park on 2/10/25.
//

import Foundation

struct FavoriteLab : Codable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}
