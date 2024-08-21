//
//  DirectoryReviewModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

struct DirectoryReviewInfoModel: Decodable {
    let universityName: String
    let departmentName: String
    let professorName: String
    let content: String
    let leadershipStyle: String
    let salaryLevel: String
    let autonomy: String
}

struct DirectoryReviewInfoResponse: Decodable {
    let httpStatus: String
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [DirectoryReviewInfoModel]?
}
