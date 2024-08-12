//
//  BoardHotModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardHotModel
struct BoardHotModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardHotResult]
}

// MARK: - BoardHotResult
struct BoardHotResult: Codable {
    let menu, boardName, title, content: String
    let commentCount, views: Int
}
