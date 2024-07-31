//
//  SchoolModel.swift
//  Sukbakji
//
//  Created by jaegu park on 7/31/24.
//

import Foundation

struct SchoolModel : Encodable {
    let search: String
}

struct SchoolResultModel : Codable {
    let status: String
    var schools: [SchoolResponse]
}

struct SchoolResponse : Codable {
    let name: String
    let code: String
    let office: String
    let level: Int
    let address: String
}
