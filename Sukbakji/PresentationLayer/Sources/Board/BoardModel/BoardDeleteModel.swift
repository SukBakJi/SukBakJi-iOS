//
//  BoardDeleteModel.swift
//  Sukbakji
//
//  Created by KKM on 4/11/25.
//

import Foundation

struct BoardDeletePostResponseModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
}
