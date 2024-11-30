//
//  FavoritesLab.swift
//  Sukbakji
//
//  Created by jaegu park on 11/30/24.
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
