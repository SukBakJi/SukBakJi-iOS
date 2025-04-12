//
//  MyProfile.swift
//  Sukbakji
//
//  Created by jaegu park on 2/10/25.
//

import Foundation

struct MyProfile : Codable {
    let name: String?
    let provider: String
    let degreeLevel: String?
    let researchTopics: [String]
}

struct EditProfile : Codable {
    let name: String
    let provider: String?
    let degreeLevel: String
    let researchTopics: [String]
}
