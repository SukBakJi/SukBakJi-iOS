//
//  DirectoryFavoriteCancelModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryFavoriteCancelPostModel
struct DirectoryFavoriteCancelPostModel: Codable {
    let labIDS: [Int]

    enum CodingKeys: String, CodingKey {
        case labIDS = "labIds"
    }
}

// MARK: - DirectoryFavoriteCancelGetModel
struct DirectoryFavoriteCancelGetModel: Codable {
    let isSuccess: Bool
    let code, message, result: String
}

