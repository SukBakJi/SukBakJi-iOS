//
//  DirectoryLabReviewListModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

struct LabReviewListResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [LabReviewListInfo]
}

struct LabReviewListInfo: Decodable {
    let universityName: String
    let departmentName: String
    let professorName: String
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}
