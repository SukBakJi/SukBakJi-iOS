//
//  DirectoryReviewModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// Main response model
struct LabReviewInfoListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LabReviewInfoListResult
}

// Result part of the response
struct LabReviewInfoListResult: Decodable {
    let reviews: [LabReviewInfo]  // 변경된 부분: LabReview -> LabReviewInfo
    let triangleGraphData: TriangleGraphData
}

// Individual review details
struct LabReviewInfo: Decodable {  // 변경된 부분: LabReview -> LabReviewInfo
    let universityName: String
    let departmentName: String
    let professorName: String
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}

// Triangle graph data
struct TriangleGraphData: Decodable {
    let leadershipAverage: Double
    let salaryAverage: Double
    let autonomyAverage: Double
}
