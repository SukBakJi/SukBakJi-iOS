//
//  DirectoryLabSearchModel.swift
//  Sukbakji
//
//  Created by KKM on 8/12/24.
//

import Foundation

// MARK: - DirectoryLabSearchModel (Request)
struct DirectoryLabSearchModel: Encodable {
    let topicName: String
}

// MARK: - DirectoryLabSearchGetModel (Response)
struct DirectoryLabSearchGetModel: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: DirectoryLabSearchResult
}

// MARK: - DirectoryLabSearchResult
struct DirectoryLabSearchResult: Decodable {
    let responseDTOList: [LabResult]
    let totalNumber: Int
}

// MARK: - LabResult
struct LabResult: Decodable {
    let labId: Int
    let labName: String
    let universityName: String
    let departmentName: String
    let professorName: String
    let researchTopics: [String]
}
