//
//  BoardSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardSearchModel
struct BoardSearchModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardSearchResult]
}

// MARK: - BoardSearchResult
struct BoardSearchResult: Codable {
    let menu, title: String
}
