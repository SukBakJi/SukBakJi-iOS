//
//  APIResponse.swift
//  Sukbakji
//
//  Created by jaegu park on 11/30/24.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: T
}
