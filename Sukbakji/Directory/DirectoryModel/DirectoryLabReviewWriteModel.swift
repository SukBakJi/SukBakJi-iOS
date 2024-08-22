//
//  DirectoryLabReviewWriteModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// Request 모델
struct LabReviewRequest: Encodable {
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}

// Response 모델
struct LabReviewResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LabReviewResult
}

struct LabReviewResult: Decodable {
    let universityName: String
    let departmentName: String
    let professorName: String
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}
