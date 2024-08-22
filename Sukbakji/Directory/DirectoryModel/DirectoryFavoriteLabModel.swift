//
//  DirectoryFavoriteLabModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

struct ScrappedLabModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: [ScrappedLabResult]
}

struct ScrappedLabResult: Decodable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}
