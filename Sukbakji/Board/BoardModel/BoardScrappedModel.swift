//
//  BoardScrappedModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardScrappedModel
struct BoardScrappedModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardScrappedResult]
}

// MARK: - BoardScrappedResult
struct BoardScrappedResult: Codable {
    let menu, boardName, title, content: String
    let commentCount, views: Int
}
