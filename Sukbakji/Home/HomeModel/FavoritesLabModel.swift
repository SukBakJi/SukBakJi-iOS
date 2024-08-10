//
//  FavoritesLabModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation

struct FavoritesLabResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: [FavoritesLabResult]
}

struct FavoritesLabResult : Codable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}
