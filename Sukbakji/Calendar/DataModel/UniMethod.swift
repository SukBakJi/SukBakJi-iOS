//
//  UniMethod.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniMethod : Codable {
    let univId: Int
    var methodList: [UniMethodList]
}

struct UniMethodList : Codable {
    let method: String
}
