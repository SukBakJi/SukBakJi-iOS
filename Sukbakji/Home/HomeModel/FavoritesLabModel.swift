//
//  FavoritesLabModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/9/24.
//

import Foundation

struct FavoritesLabResultModel : Codable {
    var favorites: [FavoritesLabResult]
}

struct FavoritesLabResult : Codable {
    let university_name: String
    let lab_name: String
    let professor_name: String
    let professor_profile: String
    let professor_academic: String
    let research_topics: [String]
}
