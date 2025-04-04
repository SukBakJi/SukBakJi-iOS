//
//  BoardDetailModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// 응답 데이터에서 null을 허용할 수 있는 필드에 대해 Optional 처리
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
    var commentCount: Int
    let views: Int
    let memberId: Int // Added memberId to identify the author
    
    // Job-specific details
    let supportField: String?  // 최종학력
    let hiringType: String?    // 채용형태
}

struct BoardComment: Decodable {
    let anonymousName: String
    let degreeLevel: String
    let content: String
    let createdDate: String
//    let memberId: Int? // Added memberId to identify the commenter, and made it Optional
}
