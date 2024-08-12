//
//  DirectoryLabReviewWriteModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabReviewWritePostModel
struct DirectoryLabReviewWritePostModel: Encodable {
    let content, leadershipStyle, salaryLevel, autonomy: String
}

// MARK: - DirectoryLabReviewWriteGetModel
struct DirectoryLabReviewWriteGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: DirectoryLabReviewWriteGetResult
}

// MARK: - DirectoryLabReviewWriteGetResult
struct DirectoryLabReviewWriteGetResult: Codable {
    let universityName, departmentName, professorName, content: String
    let leadershipStyle, salaryLevel, autonomy: String
}
