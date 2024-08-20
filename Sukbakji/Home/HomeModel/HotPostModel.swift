//
//  HotPostModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct HotPostResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: [HotPostResult]
}

struct HotPostResult : Codable {
    let postId: Int
    let menu: String
    let boardName: String
    let title: String
    let content: String
    let commentCount: Int
    let views: Int
}
