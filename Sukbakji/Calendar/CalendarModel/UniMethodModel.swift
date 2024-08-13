//
//  UniMethodModel.swift
//  Sukbakji
//
//  Created by jaegu park on 8/7/24.
//

import Foundation

struct UniMethodResultModel : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    var result: UniMethodResponse
}

struct UniMethodResponse : Codable {
    let univId: Int
    var methodList: [UniMethodList]
}

struct UniMethodList : Codable {
    let method: String
}
