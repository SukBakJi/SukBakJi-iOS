//
//  FavoriteLab.swift
//  Sukbakji
//
//  Created by jaegu park on 2/10/25.
//

import Foundation

struct FavoritesLab : Codable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}
