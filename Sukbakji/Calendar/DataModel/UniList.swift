//
//  UniList.swift
//  Sukbakji
//
//  Created by jaegu park on 11/27/24.
//

import Foundation
import RxDataSources

struct UnivList: Codable {
    let memberId: Int
    var univList: [UnivListResult]

    // 커스텀 디코딩 함수에서 null을 빈 배열로 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memberId = try container.decode(Int.self, forKey: .memberId)
        self.univList = try container.decodeIfPresent([UnivListResult].self, forKey: .univList) ?? []
    }
}

struct UnivListResult: Codable {
    let univId: Int
    let season: String
    let method: String
    let showing: Int
}

struct UnivListSection {
    var items: [UnivListResult]
}

extension UnivListSection: SectionModelType {
    typealias Item = UnivListResult
    
    init(original: UnivListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
