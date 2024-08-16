//
//  BoardListGetModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

struct BoardListGetResponseModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [BoardListResult]
}

struct BoardListResult: Decodable {
    let postId: Int
    let title: String
    let previewContent: String
    let commentCount: Int
    let views: Int
}
