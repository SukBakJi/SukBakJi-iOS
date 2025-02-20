//
//  BoardHotModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardHotModel
struct BoardHotModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [BoardHotPost]
}

// MARK: - BoardHotPost
struct BoardHotPost: Decodable {
    let postId: Int
    let menu: String
    let boardName: String
    let title: String
    let content: String
    let commentCount: Int
    let views: Int
}
