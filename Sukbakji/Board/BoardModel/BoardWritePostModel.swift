//
//  BoardPostModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// 취업후기 게시판에 사용되는 모델
struct BoardWritePostModelForJobPost: Encodable {
    let menu: String
    let boardName: String
    let supportField: String
    let job: String
    let hiringType: String
    let finalEducation: String
    let title: String
    let content: String
}

// 일반적인 게시판에 사용되는 모델
struct BoardWritePostModelForGeneralPost: Encodable {
    let menu: String
    let boardName: String
    let title: String
    let content: String
}

// 게시물 등록 후 서버로부터 받는 모델
struct BoardWritePostResponseModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BoardPostResult
}

// 응답 모델 내부 result 구조체
struct BoardPostResult: Decodable {
    let postId: Int
    let title: String
    let content: String
    let views: Int
    let createdAt: String
    let updatedAt: String
    let boardId: Int
    let memberId: Int
}
