//
//  AVModel.swift
//  Sukbakji
//
//  Created by 오현민 on 8/10/24.
//

import Foundation

struct AVModel : Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: AVResult?
}

struct AVResult : Decodable{
    let name: String?
    let provider: String?
    let degreeLevel: String?
    let researchTopics: [String]?
    let point: Int?
}

