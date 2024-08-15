//
//  BoardScrapModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardScrapModel
struct BoardScrapModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardScrapResult]
}

// MARK: - BoardScrapResult
struct BoardScrapResult: Codable {
    let menu, boardName, title, content: String
    let commentCount, views: Int
}
