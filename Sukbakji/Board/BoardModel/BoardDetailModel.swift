//
//  BoardDetailModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

struct BoardDetailModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BoardDetailResult
}

struct BoardDetailResult: Decodable {
    let menu: String
    let title: String
    let content: String
    let comments: [BoardComment]
    let commentCount: Int
    let views: Int
}

struct BoardComment: Decodable {
    let anonymousName: String
    let degreeLevel: String
    let content: String
    let createdDate: String
}
