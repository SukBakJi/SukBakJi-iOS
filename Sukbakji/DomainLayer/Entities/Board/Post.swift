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
