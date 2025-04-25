//
//  SmsResponse.swift
//  Sukbakji
//
//  Created by 오현민 on 2/28/25.
//

import Foundation

// SMS 공통 Response
struct SmsResponseDTO: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: String?
}
