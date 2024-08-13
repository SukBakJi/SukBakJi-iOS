//
//  BoardDetailModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardDetailModel
struct BoardDetailModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BoardDetailResult
}

// MARK: - BoardDetailResult
struct BoardDetailResult: Codable {
    let menu, title, content: String
    let comments: [BoardDetailComment]
    let commentCount, views: Int
}

// MARK: - BoardDetailComment
struct BoardDetailComment: Codable {
    let anonymousName, degreeLevel, content, createdDate: String
}
