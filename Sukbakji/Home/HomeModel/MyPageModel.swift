//
//  MyPageModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct MyPageResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: MyPageResult
}

struct MyPageResult : Codable {
    let name: String?
    let provider: String
    let degreeLevel: String?
    let researchTopics: [String]?
    let point: Int?
}
