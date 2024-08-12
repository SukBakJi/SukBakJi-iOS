//
//  DirectoryLabSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabSearchModel (Request)
struct DirectoryLabSearchModel: Encodable {
    let topicName: String
}

// MARK: - DirectoryLabSearchGetModel
struct DirectoryLabSearchGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [DirectoryLabSearchGetResult]
}

// MARK: - DirectoryLabSearchGetResult
struct DirectoryLabSearchGetResult: Codable {
    let labID: Int
    let universityName, department, professorName: String
    let researchTopics: [String]

    enum CodingKeys: String, CodingKey {
        case labID = "labId"
        case universityName, department, professorName, researchTopics
    }
}
