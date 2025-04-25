//
//  CommentUpdateModel.swift
//  Sukbakji
//
//  Created by KKM on 4/4/25.
//

import Foundation

struct CommentUpdateRequest: Encodable {
    let commentId: Int
    let content: String
}

struct CommentUpdateResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CommentUpdateResult
}

struct CommentUpdateResult: Decodable {
    let commentId: Int
    let content: String
    let nickname: String
    let memberId: Int
    let createdAt: String
    let updatedAt: String
}
