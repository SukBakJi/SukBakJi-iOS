//
//  BoardCommentsModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardCommentsModel
struct BoardCommentsModel: Encodable {
    let postID, memberID: Int
    let content: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case memberID = "memberId"
        case content
    }
}

// MARK: - BoardCommentsModel
struct BoardCommentsGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BoardCommentsResult
}

// MARK: - BoardCommentsResult
struct BoardCommentsResult: Codable {
    let commentID: Int
    let content, nickname, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case content, nickname, createdAt, updatedAt
    }
}
