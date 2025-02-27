//
//  ProfileModel.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation

struct PostProfileResponseDTO : Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: ProfileSettingResult?
}

struct ProfileSettingResult : Decodable{
    let name: String?
    let provider: String?
    let degreeLevel: String?
    let researchTopics: [String]?
    let point: Int?
}

