//
//  DirectoryLabReviewListModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabReviewListGetModel
struct DirectoryLabReviewListGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [DirectoryLabReviewListGetResult]
}

// MARK: - DirectoryLabReviewListGetResult
struct DirectoryLabReviewListGetResult: Codable {
    let universityName, departmentName, professorName, content: String
    let leadershipStyle, salaryLevel, autonomy: String
}
