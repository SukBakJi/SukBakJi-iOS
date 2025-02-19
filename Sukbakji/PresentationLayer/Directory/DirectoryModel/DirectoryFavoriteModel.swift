//
//  DirectoryFavoriteModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryFavoriteGetModel
struct DirectoryFavoriteGetModel: Codable {
    let isSuccess: Bool
    let code, message, result: String
}
