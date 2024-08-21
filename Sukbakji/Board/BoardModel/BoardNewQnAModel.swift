//
//  BoardNewQnAModel.swift
//  Sukbakji
//
//  Created by KKM on 8/13/24.
//

import Foundation

// MARK: - BoardNewQnAModel
struct BoardNewQnAModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [BoardNewQnAResult]
}

// MARK: - BoardNewQnAResult
struct BoardNewQnAResult: Decodable {
    let menu, title: String
}
