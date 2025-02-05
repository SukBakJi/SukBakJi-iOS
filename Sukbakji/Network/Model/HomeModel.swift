//
//  APIModel.swift
//  Sukbakji
//
//  Created by jaegu park on 1/19/25.
//

import Foundation
import RxDataSources

struct MemberId : Codable {
    let memberId: Int
}

struct FavoritesBoard : Codable {
    let postId: Int
    let title: String
    let boardName: String
}

struct FavoritesLab : Codable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}

struct HotPost : Codable {
    let postId: Int
    let menu: String
    let boardName: String
    let title: String
    let content: String
    let commentCount: Int
    let views: Int
}

struct MyProfile : Codable {
    let name: String?
    let provider: String
    let degreeLevel: String
    let researchTopics: [String]?
    let point: Int?
}

struct EditProfileResult : Codable {
    let name: String
    let degreeLevel: String
    let researchTopics: [String]
    let point: Int
}
