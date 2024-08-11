//
//  ResearchTopicModel.swift
//  Sukbakji
//
//  Created by 오현민 on 8/11/24.
//

import Foundation

struct ResearchTopicModel: Decodable {
    let isSuccess: Bool?
    let code, message: String?
    let result: ResearchTopicResult?
}

// MARK: - Result
struct ResearchTopicResult: Decodable {
    let researchTopics: [String]?
}
