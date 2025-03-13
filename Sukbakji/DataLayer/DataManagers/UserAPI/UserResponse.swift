//
//  ProfileModel.swift
//  Sukbakji
//
//  Created by 오현민 on 8/12/24.
//

import Foundation

struct PostProfileResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: ProfileSettingResult?
}

// 프로필 설정
struct ProfileSettingResult: Decodable{
    let name: String?
    let provider: String?
    let degreeLevel: String?
    let researchTopics: [String]?
    let point: Int?
}

// 학력인증 이미지 첨부
struct PostEduImageResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: String?
}

// 이름과 전화번호로 이메일 찾기 공용
struct PostUserEmailResponseDTO: Decodable {
    let isSuccess: Bool?
    let code: String?
    let message: String?
    let result: String?
}
