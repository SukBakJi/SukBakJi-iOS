//
//  DirectoryLabReviewWriteModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - Request Body Model
struct LabReviewRequest: Encodable {
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}

// MARK: - Response Body Model for Successful Review Submission
struct LabReviewResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LabReviewResult?
}

// MARK: - Lab Review Result Model
struct LabReviewResult: Decodable {
    let universityName: String
    let departmentName: String
    let professorName: String
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}
