//
//  DirectoryLabInfoMoedl.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabInfoGetModel
struct DirectoryLabInfoGetModel: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DirectoryLabInfoResult
}

// MARK: - DirectoryLabInfoResult
struct DirectoryLabInfoResult: Decodable {
    let professorName: String
    let universityName: String
    let departmentName: String
    let labLink: String
    let researchTopics: [String]
    let professorEmail: String
}
