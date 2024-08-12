//
//  BoardScrapModel.swift
//  Sukbakji
//
//  Created by KKM on 8/11/24.
//

import Foundation

// MARK: - BoardCommentsModel
struct BoardScrapModel: Codable {
    let isSuccess: Bool
    let code, message, result: String
}

