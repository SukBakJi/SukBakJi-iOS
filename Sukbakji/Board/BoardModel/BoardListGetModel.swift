//
//  BoardListGetModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardListGetModel
struct BoardListGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardListResult]
}

// MARK: - BoardListResult
struct BoardListResult: Codable {
    let postID: Int
    let title, previewContent: String
    let commentCount, views: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case title, previewContent, commentCount, views
    }
}
