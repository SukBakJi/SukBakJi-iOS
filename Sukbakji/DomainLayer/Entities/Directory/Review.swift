//
//  Review.swift
//  Sukbakji
//
//  Created by jaegu park on 6/13/25.
//

import Foundation

struct LabDetail : Codable {
    var review: [LabReview]
    var triangleGraphData: LabTriangle
}

struct LabReview : Codable, Equatable {
    var universityName: String
    var departmentName: String
    var professorName: String
    var content: String
    var leadershipStyle: String
    var salaryLevel: String
    var autonomy: String
}

struct LabTriangle : Codable {
    var leadershipAverage: Int
    var salaryAverage: Int
    var autonomyAverage: Int
}
