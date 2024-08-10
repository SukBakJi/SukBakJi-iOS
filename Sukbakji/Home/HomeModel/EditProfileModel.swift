//
//  EditProfileModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct EditProfileModel : Encodable {
    let degreeLevel: String
    let researchTopics: [String]
}

struct EditProfileResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: EditProfileResponse
}

struct EditProfileResponse : Codable {
    let name: String
    let degreeLevel: String
    let researchTopics: [String]
    let point: Int
}
