//
//  HotPost.swift
//  Sukbakji
//
//  Created by jaegu park on 2/10/25.
//

import Foundation

struct HotPost : Codable {
    let postId: Int
    let menu: String
    let boardName: String
    let title: String
    let content: String
    let commentCount: Int
    let views: Int
}
