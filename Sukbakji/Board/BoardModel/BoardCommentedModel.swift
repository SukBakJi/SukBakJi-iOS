//
//  BoardCommentedModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardCommentedModel
struct BoardCommentedModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [CommentedPost]
}

// MARK: - CommentedPost
struct CommentedPost: Decodable {
    let postId: Int
    let title: String
    let content: String
    let views: Int
    let boardName: String
    let menu: String
    let commentCount: Int
}
