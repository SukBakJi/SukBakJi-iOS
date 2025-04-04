//
//  CurrentUserResponse.swift
//  Sukbakji
//
//  Created by KKM on 4/4/25.
//

import Foundation

struct CurrentUserResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: CurrentUserResult
}

struct CurrentUserResult: Decodable {
    let memberId: Int
}
