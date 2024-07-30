//
//  SchoolModel.swift
//  Sukbakji
//
//  Created by jaegu park on 7/31/24.
//

import Foundation

struct SchoolModel : Codable {
    var content : [SchoolResponse]
}

struct SchoolResponse : Codable {
    let schoolName: String
}
