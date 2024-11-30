//
//  DateSelect.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation

struct DateSelect : Codable {
    let memberId: Int
    var scheduleList: [DateSelectList]
}

struct DateSelectList : Codable {
    let univId: Int
    let content: String
}
