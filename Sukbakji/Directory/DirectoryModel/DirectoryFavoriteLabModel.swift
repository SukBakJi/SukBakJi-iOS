//
//  DirectoryFavoriteLabModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryFavoriteLabModel
struct DirectoryFavoriteLabModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [DirectoryFavoriteLabResult]
}

// MARK: - DirectoryFavoriteLabResult
struct DirectoryFavoriteLabResult: Codable {
    let labID: Int
    let labName, universityName, departmentName, professorName: String
    let researchTopics: [String]

    enum CodingKeys: String, CodingKey {
        case labID = "labId"
        case labName, universityName, departmentName, professorName, researchTopics
    }
}
