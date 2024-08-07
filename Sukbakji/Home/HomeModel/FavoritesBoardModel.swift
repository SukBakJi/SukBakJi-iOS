//
//  FavoritesBoardModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct FavoritesBoardResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: [FavoritesBoardResult]
}

struct FavoritesBoardResult : Codable {
    let postId: Int
    let title: String
    let boardName: String
}
