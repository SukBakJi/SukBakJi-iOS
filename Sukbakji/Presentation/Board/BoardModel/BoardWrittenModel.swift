//
//  BoardWrittenModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - WrittenPostsResponse
struct WrittenPostsResponse: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [WrittenPost]
}

// MARK: - WrittenPost
struct WrittenPost: Decodable {
    let postId: Int
    let title, content: String
    let views: Int
    let boardName, menu: String
    let commentCount: Int
}
