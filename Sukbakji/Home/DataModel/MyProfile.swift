//
//  MyProfile.swift
//  Sukbakji
//
//  Created by jaegu park on 11/30/24.
//

import Foundation

struct MyProfile : Codable {
    let name: String?
    let provider: String
    let degreeLevel: String?
    let researchTopics: [String]?
    let point: Int?
}
