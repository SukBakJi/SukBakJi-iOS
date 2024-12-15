//
//  DateSelect.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation
import RxDataSources

struct DateSelect : Codable {
    let memberId: Int
    var scheduleList: [DateSelectList]
}

struct DateSelectList : Codable {
    let univId: Int
    let content: String
}

struct DateSelectSection {
    var items: [DateSelectList]
}

extension DateSelectSection: SectionModelType {
    typealias Item = DateSelectList
    
    init(original: DateSelectSection, items: [Item]) {
        self = original
        self.items = items
    }
}
