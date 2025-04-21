//
//  blockMemberId.swift
//  Sukbakji
//
//  Created by jaegu park on 4/17/25.
//

import Foundation

struct BlockMemberId : Codable {
    let blockerId: Int
    let blockedId: Int
    let isActive: Bool
}
