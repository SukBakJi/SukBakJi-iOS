//
//  DirectoryInterestTopicModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryInterestTopicGetModel
struct DirectoryInterestTopicGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: DirectoryInterestTopicResult
}

// MARK: - DirectoryInterestTopicResult
struct DirectoryInterestTopicResult: Codable {
    let topics: [String]
}
