//
//  UnivSearch.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
//

import Foundation

struct UnivSearch : Codable {
    var universityList: [UnivSearchList]
}

struct UnivSearchList : Codable, Equatable {
    let id: Int
    let name: String
}
