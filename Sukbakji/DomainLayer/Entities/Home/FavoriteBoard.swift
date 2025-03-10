//
//  FavoriteBoard.swift
//  Sukbakji
//
//  Created by jaegu park on 2/10/25.
//

import Foundation

struct FavoriteBoard : Codable {
    let postId: Int
    let title: String
    let content: String
    let views: Int
    let boardName: String
    let menu: String
    let commentCount: Int
}
