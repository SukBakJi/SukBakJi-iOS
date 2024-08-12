//
//  DirectoryLabInfoMoedl.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabInfoGetModel
struct DirectoryLabInfoGetModel: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: DirectoryLabInfoResult
}

// MARK: - DirectoryLabInfoResult
struct DirectoryLabInfoResult: Codable {
    let professorName, universityName, department, professorAcademic: String
    let professorProfile: String
    let labLink: String
    let researchTopics: [String]
}

