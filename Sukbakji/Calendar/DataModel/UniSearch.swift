//
//  UniSearch.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct UniSearch : Codable {
    var universityList: [UniSearchList]
}

struct UniSearchList : Codable {
    let id: Int
    let name: String
}
