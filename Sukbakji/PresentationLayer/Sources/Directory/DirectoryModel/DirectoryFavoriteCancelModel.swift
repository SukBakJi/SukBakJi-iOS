//
//  DirectoryFavoriteCancelModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryFavoriteCancelPostModel
struct DirectoryFavoriteCancelPostModel: Encodable {
    let labIds: [Int]
}

// MARK: - DirectoryFavoriteCancelGetModel
struct DirectoryFavoriteCancelGetModel: Decodable {
    let isSuccess: Bool
    let code, message, result: String
}
