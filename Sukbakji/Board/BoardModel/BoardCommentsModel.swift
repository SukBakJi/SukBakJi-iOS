//
//  BoardCommentsModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

struct CommentRequest: Encodable {
    let postId: Int
    let memberId: Int
    let content: String
}

struct CommentResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CommentResult
}

struct CommentResult: Decodable {
    let memberId: Int // 추가로 만든거
    let commentId: Int
    let content: String
    let nickname: String
    let createdAt: String
    let updatedAt: String
}
