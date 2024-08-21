//
//  BoardScrappedModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardScrapModel, 스크랩한 게시글 목록
struct BoardScarppedModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardScarppedResult]
}

// MARK: - BoardScrapResult
struct BoardScarppedResult: Codable {
    let postId: Int
    let menu, boardName, title, content: String
    let commentCount, views: Int
}
