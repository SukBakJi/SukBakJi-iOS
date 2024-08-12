//
//  DirectoryLabReviewSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabReviewSearchPostModel
struct DirectoryLabReviewSearchPostModel: Encodable {
    let professorName: String
}

// MARK: - DirectoryLabReviewSearchGetModel
struct DirectoryLabReviewSearchGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [DirectoryLabReviewSearchGetResult]
}

// MARK: - DirectoryLabReviewSearchGetResult
struct DirectoryLabReviewSearchGetResult: Codable {
    let universityName, departmentName, professorName, content: String
    let leadershipStyle, salaryLevel, autonomy: String
}
