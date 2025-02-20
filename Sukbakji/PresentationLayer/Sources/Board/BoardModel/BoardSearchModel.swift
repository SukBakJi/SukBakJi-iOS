//
//  BoardSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardSearchModel
struct BoardSearchModel: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [BoardSearchResult]
}

// MARK: - BoardSearchResult
struct BoardSearchResult: Codable {
    let postId: Int
    let menu: String
    let boardName: String
    let title: String
    let content: String
    let views: Int
    let commentCount: Int
}
