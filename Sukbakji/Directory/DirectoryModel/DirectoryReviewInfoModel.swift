//
//  DirectoryReviewModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryReviewInfoGetModel
struct DirectoryReviewGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: DirectoryReviewGetResult
}

// MARK: - DirectoryReviewGetResult
struct DirectoryReviewGetResult: Codable {
    let reviews: [DirectoryReviewInfoGet]
    let triangleGraphData: TriangleGraphDataGet
}

// MARK: - DirectoryReviewInfoGet
struct DirectoryReviewInfoGet: Codable {
    let universityName, departmentName, professorName, content: String
    let leadershipStyle, salaryLevel, autonomy: String
}

// MARK: - TriangleGraphDataGet
struct TriangleGraphDataGet: Codable {
    let leadershipAverage: Int
    let salaryAverage: Double
    let autonomyAverage: Int
}
