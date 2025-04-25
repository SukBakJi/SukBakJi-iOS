//
//  BoardUpdateModel.swift
//  Sukbakji
//
//  Created by KKM on 4/4/25.
//

import Foundation

struct BoardEditPostRequestModel: Encodable {
    let title: String
    let content: String
    let supportField: String?
    let job: String?
    let hiringType: String?
    let finalEducation: String?
}

struct BoardEditPostResponseModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BoardEditPostResult
}

struct BoardEditPostResult: Decodable {
    let postId: Int
    let title: String
    let content: String
    let views: Int
    let createdAt: String
    let updatedAt: String
    let boardId: Int
    let memberId: Int
}
