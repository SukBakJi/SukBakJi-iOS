//
//  BoardPostModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

struct BoardWritePostModel: Encodable {
    let menu: Int
    let boardName: String
    let title: String
    let content: String
    // 아래부터 취업후기
    let supportField: String?
    let job: String?
    let hiringType: String?
    let finalEducation: String?
}

// MARK: - BoardWriteGetModel
struct BoardWriteGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BoardWriteGetResult
}

// MARK: - BoardWriteGetResult
struct BoardWriteGetResult: Codable {
    let postID: Int
    let title, content: String
    let views: Int
    let createdAt, updatedAt: String
    let boardID, memberID: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, content, views, createdAt, updatedAt
        case boardID = "boardId"
        case memberID = "memberId"
    }
}

