//
//  DateSelect.swift
//  Sukbakji
//
//  Created by jaegu park on 2/11/25.
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
