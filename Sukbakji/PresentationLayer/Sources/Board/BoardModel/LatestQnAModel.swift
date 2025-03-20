//
//  LatestQnAModel.swift
//  Sukbakji
//
//  Created by KKM on 3/19/25.
//

import Foundation

struct LatestQnAModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [LatestQnAModelResult]
}

struct LatestQnAModelResult: Decodable {
    let menu: String
    let title: String
}
