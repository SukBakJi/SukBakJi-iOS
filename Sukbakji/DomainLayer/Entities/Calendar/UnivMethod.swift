//
//  UnivMethod.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct UnivMethod : Codable {
    let univId: Int
    var methodList: [UnivMethodList]
}

struct UnivMethodList : Codable {
    let method: String
}
