//
//  PostList.swift
//  Sukbakji
//
//  Created by jaegu park on 5/15/25.
//

import Foundation

struct Post : Codable {
    let postId: Int
    var title: String
    var previewContent: String
    var supportField: String?
    var hiringType: String?
    var commentCount: Int
    var views: Int
}

struct MyPost : Codable {
    let postId: Int
    var title: String
    var content: String
    var views: Int
    var boardName: String
    var menu: String
    var commentCount: Int
}

struct PostDetail : Codable {
    var menu: String
    var title: String
    var content: String
    var comments: [Comment]
    var supportField: String?
    var hiringType: String?
    var commentCount: Int
    var memberId: Int
    var views: Int
}

struct Comment : Codable {
    let commentId: Int
    var anonymousName: String
    var degreeLevel: String
    var content: String
    var createdDate: String
    var memberId: Int
}
